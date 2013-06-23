Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751531Ab3FWKTs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jun 2013 06:19:48 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:49800 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750883Ab3FWKTn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jun 2013 06:19:43 -0400
Date: Sun, 23 Jun 2013 12:19:40 +0200
From: Pavel Machek <pavel@ucw.cz>
To: kernel list <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org
Subject: SATA hdd refuses to reallocate a sector?
Message-ID: <20130623101940.GA4448@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

This may very well be hw problem, but...

I have error on sda4. I tried to make hdd reallocate it by writing
zeros there, but it will not. Is there special kind of write that
needs to be done to force reallocation?

Would it be possible to indicate errors when writing to known-bad
sector?

root@amd:~# time cat /dev/zero > /dev/sda4
cat: write error: No space left on device

real 9m47.083s
user 0m0.264s
sys  1m24.424s
root@amd:~# time cat /dev/sda4  | wc -c
cat: /dev/sda4: Input/output error
8959361024

real	5m9.784s
user	0m0.544s
sys	2m11.620s
root@amd:~# time cat /dev/sda1  | wc -c
797852160

real	0m23.479s
user	0m0.040s
sys	0m5.492s

dmesg says:

...
wlan0: authenticated
iwl3945 0000:03:00.0 wlan0: disabling HT as WMM/QoS is not supported by the AP
iwl3945 0000:03:00.0 wlan0: disabling VHT as WMM/QoS is not supported by the AP
wlan0: associate with 00:11:95:05:30:d7 (try 1/3)
wlan0: RX AssocResp from 00:11:95:05:30:d7 (capab=0x401 status=0 aid=2)
wlan0: associated
ata1.00: exception Emask 0x0 SAct 0xf SErr 0x0 action 0x0
ata1.00: irq_stat 0x40000001
ata1.00: failed command: READ FPDMA QUEUED
ata1.00: cmd 60/a8:00:b9:51:4b/00:00:39:00:00/40 tag 0 ncq 86016 in
         res 41/04:a8:c0:50:4b/00:00:39:00:00/00 Emask 0x1 (device error)
ata1.00: status: { DRDY ERR }
ata1.00: error: { ABRT }
ata1.00: failed command: READ FPDMA QUEUED
ata1.00: cmd 60/58:08:61:52:4b/00:00:39:00:00/40 tag 1 ncq 45056 in
         res 41/04:a8:c0:50:4b/00:00:39:00:00/00 Emask 0x1 (device error)
ata1.00: status: { DRDY ERR }
ata1.00: error: { ABRT }
ata1.00: failed command: READ FPDMA QUEUED
ata1.00: cmd 60/a8:10:b9:50:4b/00:00:39:00:00/40 tag 2 ncq 86016 in
         res 41/40:a8:c0:50:4b/00:00:39:00:00/00 Emask 0x409 (media error) <F>
ata1.00: status: { DRDY ERR }
ata1.00: error: { UNC }
ata1.00: failed command: READ FPDMA QUEUED
ata1.00: cmd 60/58:18:61:51:4b/00:00:39:00:00/40 tag 3 ncq 45056 in
         res 41/04:a8:c0:50:4b/00:00:39:00:00/00 Emask 0x1 (device error)
ata1.00: status: { DRDY ERR }
ata1.00: error: { ABRT }
ata1.00: configured for UDMA/133
sd 0:0:0:0: [sda] Unhandled sense code
sd 0:0:0:0: [sda]  
Result: hostbyte=0x00 driverbyte=0x08
sd 0:0:0:0: [sda]  
Sense Key : 0x3 [current] [descriptor]
Descriptor sense data with sense descriptors (in hex):
        72 03 11 04 00 00 00 0c 00 0a 80 00 00 00 00 00 
        39 4b 50 c0 
sd 0:0:0:0: [sda]  
ASC=0x11 ASCQ=0x4
sd 0:0:0:0: [sda] CDB: 
cdb[0]=0x28: 28 00 39 4b 50 b9 00 00 a8 00
end_request: I/O error, dev sda, sector 961237184
Buffer I/O error on device sda4, logical block 17498759
Buffer I/O error on device sda4, logical block 17498760
Buffer I/O error on device sda4, logical block 17498761
Buffer I/O error on device sda4, logical block 17498762
Buffer I/O error on device sda4, logical block 17498763
Buffer I/O error on device sda4, logical block 17498764
Buffer I/O error on device sda4, logical block 17498765
Buffer I/O error on device sda4, logical block 17498766
Buffer I/O error on device sda4, logical block 17498767
Buffer I/O error on device sda4, logical block 17498768
ata1: EH complete
ata1.00: exception Emask 0x0 SAct 0xa SErr 0x0 action 0x0
ata1.00: irq_stat 0x40000008
ata1.00: failed command: READ FPDMA QUEUED
ata1.00: cmd 60/01:18:c0:50:4b/00:00:39:00:00/40 tag 3 ncq 512 in
         res 41/40:01:c0:50:4b/00:00:39:00:00/00 Emask 0x409 (media error) <F>
ata1.00: status: { DRDY ERR }
ata1.00: error: { UNC }
ata1.00: configured for UDMA/133
sd 0:0:0:0: [sda] Unhandled sense code
sd 0:0:0:0: [sda]  
Result: hostbyte=0x00 driverbyte=0x08
sd 0:0:0:0: [sda]  
Sense Key : 0x3 [current] [descriptor]
Descriptor sense data with sense descriptors (in hex):
        72 03 11 04 00 00 00 0c 00 0a 80 00 00 00 00 00 
        39 4b 50 c0 
sd 0:0:0:0: [sda]  
ASC=0x11 ASCQ=0x4
sd 0:0:0:0: [sda] CDB: 
cdb[0]=0x28: 28 00 39 4b 50 c0 00 00 01 00
end_request: I/O error, dev sda, sector 961237184
ata1: EH complete



Disk seems mostly healthy otherwise, smart says:


smartctl 5.40 2010-07-12 r3124 [i686-pc-linux-gnu] (local build)
Copyright (C) 2002-10 by Bruce Allen, http://smartmontools.sourceforge.net

=== START OF INFORMATION SECTION ===
Model Family:     Seagate Momentus 5400.6 series
Device Model:     ST9500325AS
Serial Number:    5VE41HDA
Firmware Version: 0001SDM1
User Capacity:    500,107,862,016 bytes
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   8
ATA Standard is:  ATA-8-ACS revision 4
Local Time is:    Sun Jun 23 12:15:56 2013 CEST
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: PASSED
See vendor-specific Attribute list for marginal Attributes.

General SMART Values:
Offline data collection status:  (0x00)	Offline data collection activity
					was never started.
					Auto Offline Data Collection: Disabled.
Self-test execution status:      ( 121)	The previous self-test completed having
					the read element of the test failed.
Total time to complete Offline 
data collection: 		 (   0) seconds.
Offline data collection
capabilities: 			 (0x73) SMART execute Offline immediate.
					Auto Offline data collection on/off support.
					Suspend Offline collection upon new
					command.
					No Offline surface scan supported.
					Self-test supported.
					Conveyance Self-test supported.
					Selective Self-test supported.
SMART capabilities:            (0x0003)	Saves SMART data before entering
					power-saving mode.
					Supports SMART auto save timer.
Error logging capability:        (0x01)	Error logging supported.
					General Purpose Logging supported.
Short self-test routine 
recommended polling time: 	 (   1) minutes.
Extended self-test routine
recommended polling time: 	 ( 145) minutes.
Conveyance self-test routine
recommended polling time: 	 (   2) minutes.
SCT capabilities: 	       (0x103b)	SCT Status supported.
					SCT Error Recovery Control supported.
					SCT Feature Control supported.
					SCT Data Table supported.

SMART Attributes Data Structure revision number: 10
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      UPDATED  WHEN_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x000f   111   099   006    Pre-fail  Always       -       241452207
  3 Spin_Up_Time            0x0003   098   098   000    Pre-fail  Always       -       0
  4 Start_Stop_Count        0x0032   099   099   020    Old_age   Always       -       1036
  5 Reallocated_Sector_Ct   0x0033   100   100   036    Pre-fail  Always       -       3
  7 Seek_Error_Rate         0x000f   084   060   030    Pre-fail  Always       -       294188596
  9 Power_On_Hours          0x0032   068   068   000    Old_age   Always       -       28248
 10 Spin_Retry_Count        0x0013   100   100   097    Pre-fail  Always       -       0
 12 Power_Cycle_Count       0x0032   100   037   020    Old_age   Always       -       1023
184 End-to-End_Error        0x0032   100   100   099    Old_age   Always       -       0
187 Reported_Uncorrect      0x0032   074   074   000    Old_age   Always       -       26
188 Command_Timeout         0x0032   100   094   000    Old_age   Always       -       34360263770
189 High_Fly_Writes         0x003a   100   100   000    Old_age   Always       -       0
190 Airflow_Temperature_Cel 0x0022   052   045   045    Old_age   Always   In_the_past 48 (Lifetime Min/Max 20/55)
191 G-Sense_Error_Rate      0x0032   100   100   000    Old_age   Always       -       1
192 Power-Off_Retract_Count 0x0032   100   100   000    Old_age   Always       -       0
193 Load_Cycle_Count        0x0032   001   001   000    Old_age   Always       -       1977103
194 Temperature_Celsius     0x0022   048   055   000    Old_age   Always       -       48 (0 6 0 0)
195 Hardware_ECC_Recovered  0x001a   051   029   000    Old_age   Always       -       241452207
197 Current_Pending_Sector  0x0012   100   100   000    Old_age   Always       -       0
198 Offline_Uncorrectable   0x0010   100   100   000    Old_age   Offline      -       0
199 UDMA_CRC_Error_Count    0x003e   200   200   000    Old_age   Always       -       0
254 Free_Fall_Sensor        0x0032   100   100   000    Old_age   Always       -       0

SMART Error Log Version: 1
ATA Error Count: 24 (device log contains only the most recent five errors)
	CR = Command Register [HEX]
	FR = Features Register [HEX]
	SC = Sector Count Register [HEX]
	SN = Sector Number Register [HEX]
	CL = Cylinder Low Register [HEX]
	CH = Cylinder High Register [HEX]
	DH = Device/Head Register [HEX]
	DC = Device Command Register [HEX]
	ER = Error register [HEX]
	ST = Status register [HEX]
Powered_Up_Time is measured from power on, and printed as
DDd+hh:mm:SS.sss where DD=days, hh=hours, mm=minutes,
SS=sec, and sss=millisec. It "wraps" after 49.710 days.

Error 24 occurred at disk power-on lifetime: 28248 hours (1177 days + 0 hours)
  When the command that caused the error occurred, the device was active or idle.

  After command completion occurred, registers were:
  ER ST SC SN CL CH DH
  -- -- -- -- -- -- --
  40 51 00 ff ff ff 0f

  Commands leading to the command that caused the error were:
  CR FR SC SN CL CH DH DC   Powered_Up_Time  Command/Feature_Name
  -- -- -- -- -- -- -- --  ----------------  --------------------
  60 00 01 ff ff ff 4f 00  13d+01:29:41.468  READ FPDMA QUEUED
  60 00 a8 ff ff ff 4f 00  13d+01:29:41.468  READ FPDMA QUEUED
  60 00 58 ff ff ff 4f 00  13d+01:29:41.468  READ FPDMA QUEUED
  60 00 58 ff ff ff 4f 00  13d+01:29:41.467  READ FPDMA QUEUED
  27 00 00 00 00 00 e0 00  13d+01:29:41.465  READ NATIVE MAX ADDRESS EXT

Error 23 occurred at disk power-on lifetime: 28248 hours (1177 days + 0 hours)
  When the command that caused the error occurred, the device was active or idle.

  After command completion occurred, registers were:
  ER ST SC SN CL CH DH
  -- -- -- -- -- -- --
  40 51 00 ff ff ff 0f

  Commands leading to the command that caused the error were:
  CR FR SC SN CL CH DH DC   Powered_Up_Time  Command/Feature_Name
  -- -- -- -- -- -- -- --  ----------------  --------------------
  60 00 58 ff ff ff 4f 00  13d+01:29:39.015  READ FPDMA QUEUED
  60 00 08 ff ff ff 4f 00  13d+01:29:38.699  READ FPDMA QUEUED
  60 00 a8 ff ff ff 4f 00  13d+01:29:38.699  READ FPDMA QUEUED
  60 00 a8 ff ff ff 4f 00  13d+01:29:38.699  READ FPDMA QUEUED
  60 00 a8 ff ff ff 4f 00  13d+01:29:38.698  READ FPDMA QUEUED

Error 22 occurred at disk power-on lifetime: 28248 hours (1177 days + 0 hours)
  When the command that caused the error occurred, the device was active or idle.

  After command completion occurred, registers were:
  ER ST SC SN CL CH DH
  -- -- -- -- -- -- --
  40 51 00 ff ff ff 0f

  Commands leading to the command that caused the error were:
  CR FR SC SN CL CH DH DC   Powered_Up_Time  Command/Feature_Name
  -- -- -- -- -- -- -- --  ----------------  --------------------
  60 00 08 ff ff ff 4f 00  13d+01:08:08.641  READ FPDMA QUEUED
  27 00 00 00 00 00 e0 00  13d+01:08:08.641  READ NATIVE MAX ADDRESS EXT
  ec 00 00 00 00 00 a0 00  13d+01:08:08.639  IDENTIFY DEVICE
  ef 03 46 00 00 00 a0 00  13d+01:08:08.639  SET FEATURES [Set transfer mode]
  27 00 00 00 00 00 e0 00  13d+01:08:08.638  READ NATIVE MAX ADDRESS EXT

Error 21 occurred at disk power-on lifetime: 28248 hours (1177 days + 0 hours)
  When the command that caused the error occurred, the device was active or idle.

  After command completion occurred, registers were:
  ER ST SC SN CL CH DH
  -- -- -- -- -- -- --
  40 51 00 ff ff ff 0f

  Commands leading to the command that caused the error were:
  CR FR SC SN CL CH DH DC   Powered_Up_Time  Command/Feature_Name
  -- -- -- -- -- -- -- --  ----------------  --------------------
  60 00 08 ff ff ff 4f 00  13d+01:08:06.101  READ FPDMA QUEUED
  60 00 00 ff ff ff 4f 00  13d+01:08:06.099  READ FPDMA QUEUED
  27 00 00 00 00 00 e0 00  13d+01:08:06.098  READ NATIVE MAX ADDRESS EXT
  ec 00 00 00 00 00 a0 00  13d+01:08:06.097  IDENTIFY DEVICE
  ef 03 46 00 00 00 a0 00  13d+01:08:06.096  SET FEATURES [Set transfer mode]

Error 20 occurred at disk power-on lifetime: 28248 hours (1177 days + 0 hours)
  When the command that caused the error occurred, the device was active or idle.

  After command completion occurred, registers were:
  ER ST SC SN CL CH DH
  -- -- -- -- -- -- --
  40 51 00 ff ff ff 0f

  Commands leading to the command that caused the error were:
  CR FR SC SN CL CH DH DC   Powered_Up_Time  Command/Feature_Name
  -- -- -- -- -- -- -- --  ----------------  --------------------
  60 00 00 ff ff ff 4f 00  13d+01:07:55.327  READ FPDMA QUEUED
  60 00 00 ff ff ff 4f 00  13d+01:07:55.325  READ FPDMA QUEUED
  60 00 00 ff ff ff 4f 00  13d+01:07:55.324  READ FPDMA QUEUED
  60 00 00 ff ff ff 4f 00  13d+01:07:55.323  READ FPDMA QUEUED
  60 00 00 ff ff ff 4f 00  13d+01:07:55.320  READ FPDMA QUEUED

SMART Self-test log structure revision number 1
Num  Test_Description    Status                  Remaining  LifeTime(hours)  LBA_of_first_error
# 1  Extended offline    Completed: read failure       90%     28233         961237188
# 2  Extended offline    Completed: read failure       90%     28227         961237188
# 3  Extended offline    Completed without error       00%     23826         -
# 4  Extended offline    Completed without error       00%      9419         -
# 5  Extended offline    Completed without error       00%        40         -

SMART Selective self-test log data structure revision number 1
 SPAN  MIN_LBA  MAX_LBA  CURRENT_TEST_STATUS
    1        0        0  Not_testing
    2        0        0  Not_testing
    3        0        0  Not_testing
    4        0        0  Not_testing
    5        0        0  Not_testing
Selective self-test flags (0x0):
  After scanning selected spans, do NOT read-scan remainder of disk.
If Selective self-test is pending on power-up, resume after 0 minute delay.

(Ok, this is slightly interesting:

 12 Power_Cycle_Count       0x0032   100   037   020    Old_age   Always       -       1023

AFAICT it indicates that power cycle count was too high but got
better. Ouch?)

Any ideas? Thanks,

									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
