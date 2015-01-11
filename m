Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752542AbbAKVoo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 16:44:44 -0500
Received: from smtp-2.concepts.nl ([213.197.30.125]:46426 "EHLO
	smtp-2.concepts.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751120AbbAKVon (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 16:44:43 -0500
Message-ID: <54B2EEC5.7050805@xmsnet.nl>
Date: Sun, 11 Jan 2015 22:44:37 +0100
From: Hans de Bruin <jmdebruin@xmsnet.nl>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.8.1
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        David Henningsson <david.henningsson@canonical.com>
Subject: Re: 3.19-rc1 regression bisected No sound on Dell Latitude d430
References: <54B26ACE.90406@xmsnet.nl> <s5hy4p92ue0.wl-tiwai@suse.de>
In-Reply-To: <s5hy4p92ue0.wl-tiwai@suse.de>
Content-Type: multipart/mixed;
 boundary="------------060202030607030805060701"
X-Concepts-MailScanner-Information: Please contact abuse@concepts.nl for more information
X-Concepts-MailScanner-ID: 1YAQJJ-0006dT-Iw
X-Concepts-MailScanner: Found to be clean
X-Concepts-MailScanner-SpamCheck: 
X-Concepts-MailScanner-From: jmdebruin@xmsnet.nl
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060202030607030805060701
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 01/11/2015 04:45 PM, Takashi Iwai wrote:
> At Sun, 11 Jan 2015 13:21:34 +0100,
> Hans de Bruin wrote:
>>
>> This commit:
>>
>> commit 3abb4f4d0e7aaad0d12004b5057f4486a688752b
>> Author: David Henningsson <david.henningsson@canonical.com>
>> Date:   Thu Oct 16 15:33:46 2014 +0200
>>
>>       ALSA: hda - Use "Line Out" name instead of "PCM" when there are
>> other outputs
>>
>>       In case there are speakers or headphones as well, anything that only
>>       covers the line out should not be labelled "PCM". Let's name it
>>       "Line Out" instead for clarity.
>>
>>       Signed-off-by: David Henningsson <david.henningsson@canonical.com>
>>       Signed-off-by: Takashi Iwai <tiwai@suse.de>
>>
>> breaks the sound on my dell laptop.
>
> What sound?  From the speaker, the headphone or the dock output?

The speaker. I have not checked the other exits

> Are you using PulseAudio?

No

> What if you adjust/unmute the volume
> (likely "Line Out") manually?

running 3.18 alsamixer show these options:

Master
PCM
Mic Boost
Auto Mute mode

PCM affects the volume of the speaker.

running 3.19-rc1 alsamixer show these options:

Master
PCM
Line Out
Mic Boost
Auto Mute mode

Line out now controls the vole of the speaker (this 'new' channel had 
volume 0 so did not hear anything). Changing PCM has no effect.

> In anyway, please give alsa-info.sh output.  Run it with --no-upload
> option and attach the output.

I have attached both the 3.18.0 and a 3.19-rc1 ouputs


-- 
Hans

--------------060202030607030805060701
Content-Type: text/plain; charset=ISO-8859-1;
 name="alsa-info-3.18.0"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="alsa-info-3.18.0"

upload=true&script=true&cardinfo=
!!################################
!!ALSA Information Script v 0.4.64
!!################################

!!Script ran on: Sun Jan 11 18:06:43 UTC 2015


!!Linux Distribution
!!------------------

NAME=Slackware ID=slackware PRETTY_NAME="Slackware 14.1" CPE_NAME="cpe:/o:slackware:slackware_linux:14.1" HOME_URL="http://slackware.com/" SUPPORT_URL="http://www.linuxquestions.org/questions/slackware-14/" BUG_REPORT_URL="http://www.linuxquestions.org/questions/slackware-14/" Slackware 14.1


!!DMI Information
!!---------------

Manufacturer:      Dell Inc.
Product Name:      Latitude D430                   
Product Version:   
Firmware Version:  A02


!!Kernel Information
!!------------------

Kernel release:    3.18.0
Operating System:  GNU/Linux
Architecture:      i686
Processor:         Intel(R) Core(TM) Solo CPU     U1400  @ 1.20GHz
SMP Enabled:       No


!!ALSA Version
!!------------

Driver version:     k3.18.0
Library version:    1.0.27.2
Utilities version:  1.0.27.1


!!Loaded ALSA modules
!!-------------------



!!Sound Servers on this system
!!----------------------------

ESound Daemon:
      Installed - Yes (/usr/bin/esd)
      Running - No


!!Soundcards recognised by ALSA
!!-----------------------------

 0 [Intel          ]: HDA-Intel - HDA Intel
                      HDA Intel at 0xefebc000 irq 21


!!PCI Soundcards installed in the system
!!--------------------------------------

00:1b.0 Audio device: Intel Corporation NM10/ICH7 Family High Definition Audio Controller (rev 01)


!!Advanced information - PCI Vendor/Device/Subsystem ID's
!!-------------------------------------------------------

00:1b.0 0403: 8086:27d8 (rev 01)
	Subsystem: 1028:0201


!!Loaded sound module options
!!---------------------------


!!HDA-Intel Codec information
!!---------------------------
--startcollapse--

Codec: SigmaTel STAC9200
Address: 0
AFG Function Id: 0x1 (unsol 1)
Vendor Id: 0x83847690
Subsystem Id: 0x10280201
Revision Id: 0x102201
No Modem Function Group found
Default PCM:
    rates [0x7e0]: 44100 48000 88200 96000 176400 192000
    bits [0xe]: 16 20 24
    formats [0x1]: PCM
Default Amp-In caps: N/A
Default Amp-Out caps: ofs=0x1f, nsteps=0x1f, stepsize=0x05, mute=1
State of AFG node 0x01:
  Power states:  D0 D1 D2 D3
  Power: setting=D0, actual=D0
GPIO: io=4, o=0, i=0, unsolicited=1, wake=1
  IO[0]: enable=0, dir=0, wake=0, sticky=0, data=0, unsol=0
  IO[1]: enable=0, dir=0, wake=0, sticky=0, data=0, unsol=0
  IO[2]: enable=0, dir=0, wake=0, sticky=0, data=0, unsol=0
  IO[3]: enable=0, dir=0, wake=0, sticky=0, data=0, unsol=0
Node 0x02 [Audio Output] wcaps 0xd0401: Stereo
  Device: name="STAC9200 Analog", type="Audio", device=0
  Converter: stream=5, channel=0
  Power states: 
  Power: setting=D0, actual=D0
  Delay: 13 samples
Node 0x03 [Audio Input] wcaps 0x1d0541: Stereo
  Device: name="STAC9200 Analog", type="Audio", device=0
  Converter: stream=1, channel=0
  SDI-Select: 0
  Power states: 
  Power: setting=D0, actual=D0
  Delay: 13 samples
  Connection: 1
     0x0a
  Processing caps: benign=0, ncoeff=0
Node 0x04 [Audio Input] wcaps 0x140311: Stereo Digital
  Converter: stream=0, channel=0
  SDI-Select: 0
  Digital:
  Digital category: 0x0
  IEC Coding Type: 0x0
  PCM:
    rates [0x160]: 44100 48000 96000
    bits [0xe]: 16 20 24
    formats [0x5]: PCM AC3
  Delay: 4 samples
  Connection: 1
     0x08
Node 0x05 [Audio Output] wcaps 0x40211: Stereo Digital
  Converter: stream=0, channel=0
  Digital:
  Digital category: 0x0
  IEC Coding Type: 0x0
  PCM:
    rates [0x1e0]: 44100 48000 88200 96000
    bits [0xe]: 16 20 24
    formats [0x5]: PCM AC3
  Delay: 4 samples
Node 0x06 [Vendor Defined Widget] wcaps 0xf30201: Stereo Digital
  Delay: 3 samples
Node 0x07 [Audio Selector] wcaps 0x300901: Stereo R/L
  Connection: 3
     0x02* 0x08 0x0a
Node 0x08 [Pin Complex] wcaps 0x430681: Stereo Digital
  Pincap 0x00010024: IN EAPD Detect
  EAPD 0x2: EAPD
  Pin Default 0x40f000f0: [N/A] Other at Ext N/A
    Conn = Unknown, Color = Unknown
    DefAssociation = 0xf, Sequence = 0x0
  Pin-ctls: 0x00:
  Unsolicited: tag=00, enabled=0
  Power states: 
  Power: setting=D0, actual=D0
  Delay: 3 samples
Node 0x09 [Pin Complex] wcaps 0x400301: Stereo Digital
  Pincap 0x00000010: OUT
  Pin Default 0x40f000f1: [N/A] Other at Ext N/A
    Conn = Unknown, Color = Unknown
    DefAssociation = 0xf, Sequence = 0x1
  Pin-ctls: 0x00:
  Connection: 2
     0x05* 0x0a
Node 0x0a [Audio Selector] wcaps 0x30090d: Stereo Amp-Out R/L
  Control: name="Capture Volume", index=0, device=0
    ControlAmp: chs=3, dir=Out, idx=0, ofs=0
  Control: name="Capture Switch", index=0, device=0
    ControlAmp: chs=3, dir=Out, idx=0, ofs=0
  Amp-Out caps: ofs=0x00, nsteps=0x0f, stepsize=0x05, mute=1
  Amp-Out vals:  [0x80 0x80]
  Connection: 1
     0x0c
Node 0x0b [Audio Selector] wcaps 0x300105: Stereo Amp-Out
  Control: name="PCM Playback Volume", index=0, device=0
    ControlAmp: chs=3, dir=Out, idx=0, ofs=0
  Control: name="PCM Playback Switch", index=0, device=0
    ControlAmp: chs=3, dir=Out, idx=0, ofs=0
  Amp-Out caps: N/A
  Amp-Out vals:  [0x1f 0x1f]
  Connection: 1
     0x07
Node 0x0c [Audio Selector] wcaps 0x30010d: Stereo Amp-Out
  Control: name="Mic Boost Volume", index=0, device=0
    ControlAmp: chs=3, dir=Out, idx=0, ofs=0
  Amp-Out caps: ofs=0x00, nsteps=0x04, stepsize=0x27, mute=0
  Amp-Out vals:  [0x00 0x00]
  Connection: 5
     0x10 0x0f* 0x0e 0x0d 0x12
Node 0x0d [Pin Complex] wcaps 0x400181: Stereo
  Control: name="Headphone Jack", index=0, device=0
  Pincap 0x0000003f: IN OUT HP Detect Trigger ImpSense
  Pin Default 0x0321101f: [Jack] HP Out at Ext Left
    Conn = 1/8, Color = Black
    DefAssociation = 0x1, Sequence = 0xf
  Pin-ctls: 0xc0: OUT HP
  Unsolicited: tag=01, enabled=1
  Connection: 1
     0x0b
Node 0x0e [Pin Complex] wcaps 0x400181: Stereo
  Control: name="Speaker Phantom Jack", index=0, device=0
  Pincap 0x0000003f: IN OUT HP Detect Trigger ImpSense
  Pin Default 0x90170110: [Fixed] Speaker at Int N/A
    Conn = Analog, Color = Unknown
    DefAssociation = 0x1, Sequence = 0x0
    Misc = NO_PRESENCE
  Pin-ctls: 0x40: OUT
  Unsolicited: tag=00, enabled=0
  Connection: 1
     0x0b
Node 0x0f [Pin Complex] wcaps 0x400181: Stereo
  Control: name="Mic Phantom Jack", index=0, device=0
  Pincap 0x00000037: IN OUT Detect Trigger ImpSense
  Pin Default 0x90a70120: [Fixed] Mic at Int N/A
    Conn = Analog, Color = Unknown
    DefAssociation = 0x2, Sequence = 0x0
    Misc = NO_PRESENCE
  Pin-ctls: 0x20: IN
  Unsolicited: tag=00, enabled=0
  Connection: 1
     0x0b
Node 0x10 [Pin Complex] wcaps 0x400181: Stereo
  Control: name="Line Jack", index=0, device=0
  Pincap 0x00001737: IN OUT Detect Trigger ImpSense
    Vref caps: HIZ 50 GRD 80
  Pin Default 0x0381102e: [Jack] Line In at Ext Left
    Conn = 1/8, Color = Black
    DefAssociation = 0x2, Sequence = 0xe
  Pin-ctls: 0x20: IN VREF_HIZ
  Unsolicited: tag=03, enabled=1
  Connection: 1
     0x0b
Node 0x11 [Pin Complex] wcaps 0x400104: Mono Amp-Out
  Amp-Out caps: N/A
  Amp-Out vals:  [0x9f]
  Pincap 0x00000010: OUT
  Pin Default 0x40f000f2: [N/A] Other at Ext N/A
    Conn = Unknown, Color = Unknown
    DefAssociation = 0xf, Sequence = 0x2
  Pin-ctls: 0x00:
  Connection: 1
     0x13
Node 0x12 [Pin Complex] wcaps 0x400001: Stereo
  Pincap 0x00000020: IN
  Pin Default 0x40f000f3: [N/A] Other at Ext N/A
    Conn = Unknown, Color = Unknown
    DefAssociation = 0xf, Sequence = 0x3
  Pin-ctls: 0x20: IN
Node 0x13 [Audio Mixer] wcaps 0x200100: Mono
  Connection: 1
     0x07
Node 0x14 [Beep Generator Widget] wcaps 0x70000c: Mono Amp-Out
  Amp-Out caps: ofs=0x03, nsteps=0x03, stepsize=0x17, mute=1
  Amp-Out vals:  [0x83]
Codec: Conexant ID 2c06
Address: 1
MFG Function Id: 0x2 (unsol 1)
Vendor Id: 0x14f12c06
Subsystem Id: 0x14f1000f
Revision Id: 0x100000
Modem Function Group: 0x2
--endcollapse--


!!ALSA Device nodes
!!-----------------

crw-rw---- 1 root audio 116,  2 Jan 11 18:58 /dev/snd/controlC0
crw-rw---- 1 root audio 116,  4 Jan 11 18:59 /dev/snd/pcmC0D0c
crw-rw---- 1 root audio 116,  3 Jan 11 18:59 /dev/snd/pcmC0D0p
crw-rw---- 1 root audio 116,  1 Jan 11 18:58 /dev/snd/seq
crw-rw---- 1 root audio 116, 33 Jan 11 18:58 /dev/snd/timer

/dev/snd/by-path:
total 0
drwxr-xr-x 2 root root  60 Jan 11  2015 .
drwxr-xr-x 3 root root 160 Jan 11  2015 ..
lrwxrwxrwx 1 root root  12 Jan 11 18:58 pci-0000:00:1b.0 -> ../controlC0


!!Aplay/Arecord output
!!--------------------

APLAY

**** List of PLAYBACK Hardware Devices ****
card 0: Intel [HDA Intel], device 0: STAC9200 Analog [STAC9200 Analog]
  Subdevices: 1/1
  Subdevice #0: subdevice #0

ARECORD

**** List of CAPTURE Hardware Devices ****
card 0: Intel [HDA Intel], device 0: STAC9200 Analog [STAC9200 Analog]
  Subdevices: 1/1
  Subdevice #0: subdevice #0

!!Amixer output
!!-------------

!!-------Mixer controls for card 0 [Intel]

Card hw:0 'Intel'/'HDA Intel at 0xefebc000 irq 21'
  Mixer name	: 'SigmaTel STAC9200'
  Components	: 'HDA:83847690,10280201,00102201 HDA:14f12c06,14f1000f,00100000'
  Controls      : 16
  Simple ctrls  : 8
Simple mixer control 'Master',0
  Capabilities: pvolume pvolume-joined pswitch pswitch-joined
  Playback channels: Mono
  Limits: Playback 0 - 31
  Mono: Playback 31 [100%] [0.00dB] [on]
Simple mixer control 'PCM',0
  Capabilities: pvolume pswitch
  Playback channels: Front Left - Front Right
  Limits: Playback 0 - 31
  Mono:
  Front Left: Playback 31 [100%] [0.00dB] [on]
  Front Right: Playback 31 [100%] [0.00dB] [on]
Simple mixer control 'Line',0
  Capabilities: cswitch cswitch-joined cswitch-exclusive
  Capture exclusive group: 0
  Capture channels: Mono
  Mono: Capture [off]
Simple mixer control 'Mic',0
  Capabilities: cswitch cswitch-joined cswitch-exclusive
  Capture exclusive group: 0
  Capture channels: Mono
  Mono: Capture [on]
Simple mixer control 'Mic Boost',0
  Capabilities: volume
  Playback channels: Front Left - Front Right
  Capture channels: Front Left - Front Right
  Limits: 0 - 4
  Front Left: 0 [0%] [0.00dB]
  Front Right: 0 [0%] [0.00dB]
Simple mixer control 'Capture',0
  Capabilities: cvolume cswitch
  Capture channels: Front Left - Front Right
  Limits: Capture 0 - 15
  Front Left: Capture 0 [0%] [0.00dB] [off]
  Front Right: Capture 0 [0%] [0.00dB] [off]
Simple mixer control 'Auto-Mute Mode',0
  Capabilities: enum
  Items: 'Disabled' 'Enabled'
  Item0: 'Enabled'
Simple mixer control 'Digital',0
  Capabilities: cvolume
  Capture channels: Front Left - Front Right
  Limits: Capture 0 - 120
  Front Left: Capture 60 [50%] [0.00dB]
  Front Right: Capture 60 [50%] [0.00dB]


!!Alsactl output
!!--------------

--startcollapse--
state.Intel {
	control.1 {
		iface MIXER
		name 'PCM Playback Volume'
		value.0 31
		value.1 31
		comment {
			access 'read write'
			type INTEGER
			count 2
			range '0 - 31'
			dbmin -9999999
			dbmax 0
			dbvalue.0 0
			dbvalue.1 0
		}
	}
	control.2 {
		iface MIXER
		name 'PCM Playback Switch'
		value.0 true
		value.1 true
		comment {
			access 'read write'
			type BOOLEAN
			count 2
		}
	}
	control.3 {
		iface MIXER
		name 'Auto-Mute Mode'
		value Enabled
		comment {
			access 'read write'
			type ENUMERATED
			count 1
			item.0 Disabled
			item.1 Enabled
		}
	}
	control.4 {
		iface MIXER
		name 'Capture Source'
		value Mic
		comment {
			access 'read write'
			type ENUMERATED
			count 1
			item.0 Mic
			item.1 Line
		}
	}
	control.5 {
		iface MIXER
		name 'Capture Volume'
		value.0 0
		value.1 0
		comment {
			access 'read write'
			type INTEGER
			count 2
			range '0 - 15'
			dbmin 0
			dbmax 2250
			dbvalue.0 0
			dbvalue.1 0
		}
	}
	control.6 {
		iface MIXER
		name 'Capture Switch'
		value.0 false
		value.1 false
		comment {
			access 'read write'
			type BOOLEAN
			count 2
		}
	}
	control.7 {
		iface MIXER
		name 'Mic Boost Volume'
		value.0 0
		value.1 0
		comment {
			access 'read write'
			type INTEGER
			count 2
			range '0 - 4'
			dbmin 0
			dbmax 4000
			dbvalue.0 0
			dbvalue.1 0
		}
	}
	control.8 {
		iface MIXER
		name 'Master Playback Volume'
		value 31
		comment {
			access 'read write'
			type INTEGER
			count 1
			range '0 - 31'
			dbmin -9999999
			dbmax 0
			dbvalue.0 0
		}
	}
	control.9 {
		iface MIXER
		name 'Master Playback Switch'
		value true
		comment {
			access 'read write'
			type BOOLEAN
			count 1
		}
	}
	control.10 {
		iface CARD
		name 'Mic Phantom Jack'
		value true
		comment {
			access read
			type BOOLEAN
			count 1
		}
	}
	control.11 {
		iface CARD
		name 'Line Jack'
		value false
		comment {
			access read
			type BOOLEAN
			count 1
		}
	}
	control.12 {
		iface CARD
		name 'Headphone Jack'
		value false
		comment {
			access read
			type BOOLEAN
			count 1
		}
	}
	control.13 {
		iface CARD
		name 'Speaker Phantom Jack'
		value true
		comment {
			access read
			type BOOLEAN
			count 1
		}
	}
	control.14 {
		iface PCM
		name 'Playback Channel Map'
		value.0 0
		value.1 0
		comment {
			access read
			type INTEGER
			count 2
			range '0 - 36'
		}
	}
	control.15 {
		iface PCM
		name 'Capture Channel Map'
		value.0 0
		value.1 0
		comment {
			access read
			type INTEGER
			count 2
			range '0 - 36'
		}
	}
	control.16 {
		iface MIXER
		name 'Digital Capture Volume'
		value.0 60
		value.1 60
		comment {
			access 'read write user'
			type INTEGER
			count 2
			range '0 - 120'
			tlv '0000000100000008fffff44800000032'
			dbmin -3000
			dbmax 3000
			dbvalue.0 0
			dbvalue.1 0
		}
	}
}
--endcollapse--


!!All Loaded Modules
!!------------------

Module


!!ALSA/HDA dmesg
!!--------------

[    0.665397] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[    0.669457] sound hdaudioC0D0: autoconfig: line_outs=1 (0xe/0x0/0x0/0x0/0x0) type:speaker
[    0.669475] sound hdaudioC0D0:    speaker_outs=0 (0x0/0x0/0x0/0x0/0x0)
[    0.669488] sound hdaudioC0D0:    hp_outs=1 (0xd/0x0/0x0/0x0/0x0)
[    0.669499] sound hdaudioC0D0:    mono: mono_out=0x0
[    0.669509] sound hdaudioC0D0:    inputs:
[    0.669518] sound hdaudioC0D0:      Mic=0xf
[    0.669528] sound hdaudioC0D0:      Line=0x10
[    0.670518] sound hdaudioC0D1: autoconfig: line_outs=0 (0x0/0x0/0x0/0x0/0x0) type:line
[    0.670534] sound hdaudioC0D1:    speaker_outs=0 (0x0/0x0/0x0/0x0/0x0)
[    0.670547] sound hdaudioC0D1:    hp_outs=0 (0x0/0x0/0x0/0x0/0x0)
[    0.670558] sound hdaudioC0D1:    mono: mono_out=0x0
[    0.670568] sound hdaudioC0D1:    inputs:
[    0.720614] ata1.00: ATA-6: TOSHIBA MK4009GAL, BS111G, max UDMA/100
--
[    4.479045]      nameserver0=10.10.0.1
[    4.486690] ALSA device list:
[    4.490484]   #0: HDA Intel at 0xefebc000 irq 21
[    4.506025] VFS: Mounted root (nfs filesystem) readonly on device 0:13.



--------------060202030607030805060701
Content-Type: text/plain; charset=ISO-8859-1;
 name="alsa-info-3.19-rc1"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="alsa-info-3.19-rc1"

upload=true&script=true&cardinfo=
!!################################
!!ALSA Information Script v 0.4.64
!!################################

!!Script ran on: Sun Jan 11 19:19:07 UTC 2015


!!Linux Distribution
!!------------------

NAME=Slackware ID=slackware PRETTY_NAME="Slackware 14.1" CPE_NAME="cpe:/o:slackware:slackware_linux:14.1" HOME_URL="http://slackware.com/" SUPPORT_URL="http://www.linuxquestions.org/questions/slackware-14/" BUG_REPORT_URL="http://www.linuxquestions.org/questions/slackware-14/" Slackware 14.1


!!DMI Information
!!---------------

Manufacturer:      Dell Inc.
Product Name:      Latitude D430                   
Product Version:   
Firmware Version:  A02


!!Kernel Information
!!------------------

Kernel release:    3.19.0-rc1bisect
Operating System:  GNU/Linux
Architecture:      i686
Processor:         Intel(R) Core(TM) Solo CPU     U1400  @ 1.20GHz
SMP Enabled:       No


!!ALSA Version
!!------------

Driver version:     k3.19.0-rc1bisect
Library version:    1.0.27.2
Utilities version:  1.0.27.1


!!Loaded ALSA modules
!!-------------------



!!Sound Servers on this system
!!----------------------------

ESound Daemon:
      Installed - Yes (/usr/bin/esd)
      Running - No


!!Soundcards recognised by ALSA
!!-----------------------------

 0 [Intel          ]: HDA-Intel - HDA Intel
                      HDA Intel at 0xefebc000 irq 21


!!PCI Soundcards installed in the system
!!--------------------------------------

00:1b.0 Audio device: Intel Corporation NM10/ICH7 Family High Definition Audio Controller (rev 01)


!!Advanced information - PCI Vendor/Device/Subsystem ID's
!!-------------------------------------------------------

00:1b.0 0403: 8086:27d8 (rev 01)
	Subsystem: 1028:0201


!!Loaded sound module options
!!---------------------------


!!HDA-Intel Codec information
!!---------------------------
--startcollapse--

Codec: SigmaTel STAC9200
Address: 0
AFG Function Id: 0x1 (unsol 1)
Vendor Id: 0x83847690
Subsystem Id: 0x10280201
Revision Id: 0x102201
No Modem Function Group found
Default PCM:
    rates [0x7e0]: 44100 48000 88200 96000 176400 192000
    bits [0xe]: 16 20 24
    formats [0x1]: PCM
Default Amp-In caps: N/A
Default Amp-Out caps: ofs=0x1f, nsteps=0x1f, stepsize=0x05, mute=1
State of AFG node 0x01:
  Power states:  D0 D1 D2 D3
  Power: setting=D0, actual=D0
GPIO: io=4, o=0, i=0, unsolicited=1, wake=1
  IO[0]: enable=0, dir=0, wake=0, sticky=0, data=0, unsol=0
  IO[1]: enable=0, dir=0, wake=0, sticky=0, data=0, unsol=0
  IO[2]: enable=0, dir=0, wake=0, sticky=0, data=0, unsol=0
  IO[3]: enable=0, dir=0, wake=0, sticky=0, data=0, unsol=0
Node 0x02 [Audio Output] wcaps 0xd0401: Stereo
  Device: name="STAC9200 Analog", type="Audio", device=0
  Converter: stream=5, channel=0
  Power states: 
  Power: setting=D0, actual=D0
  Delay: 13 samples
Node 0x03 [Audio Input] wcaps 0x1d0541: Stereo
  Device: name="STAC9200 Analog", type="Audio", device=0
  Converter: stream=1, channel=0
  SDI-Select: 0
  Power states: 
  Power: setting=D0, actual=D0
  Delay: 13 samples
  Connection: 1
     0x0a
  Processing caps: benign=0, ncoeff=0
Node 0x04 [Audio Input] wcaps 0x140311: Stereo Digital
  Converter: stream=0, channel=0
  SDI-Select: 0
  Digital:
  Digital category: 0x0
  IEC Coding Type: 0x0
  PCM:
    rates [0x160]: 44100 48000 96000
    bits [0xe]: 16 20 24
    formats [0x5]: PCM AC3
  Delay: 4 samples
  Connection: 1
     0x08
Node 0x05 [Audio Output] wcaps 0x40211: Stereo Digital
  Converter: stream=0, channel=0
  Digital:
  Digital category: 0x0
  IEC Coding Type: 0x0
  PCM:
    rates [0x1e0]: 44100 48000 88200 96000
    bits [0xe]: 16 20 24
    formats [0x5]: PCM AC3
  Delay: 4 samples
Node 0x06 [Vendor Defined Widget] wcaps 0xf30201: Stereo Digital
  Delay: 3 samples
Node 0x07 [Audio Selector] wcaps 0x300901: Stereo R/L
  Connection: 3
     0x02* 0x08 0x0a
Node 0x08 [Pin Complex] wcaps 0x430681: Stereo Digital
  Pincap 0x00010024: IN EAPD Detect
  EAPD 0x2: EAPD
  Pin Default 0x40f000f0: [N/A] Other at Ext N/A
    Conn = Unknown, Color = Unknown
    DefAssociation = 0xf, Sequence = 0x0
  Pin-ctls: 0x00:
  Unsolicited: tag=00, enabled=0
  Power states: 
  Power: setting=D0, actual=D0
  Delay: 3 samples
Node 0x09 [Pin Complex] wcaps 0x400301: Stereo Digital
  Pincap 0x00000010: OUT
  Pin Default 0x40f000f1: [N/A] Other at Ext N/A
    Conn = Unknown, Color = Unknown
    DefAssociation = 0xf, Sequence = 0x1
  Pin-ctls: 0x00:
  Connection: 2
     0x05* 0x0a
Node 0x0a [Audio Selector] wcaps 0x30090d: Stereo Amp-Out R/L
  Control: name="Capture Volume", index=0, device=0
    ControlAmp: chs=3, dir=Out, idx=0, ofs=0
  Control: name="Capture Switch", index=0, device=0
    ControlAmp: chs=3, dir=Out, idx=0, ofs=0
  Amp-Out caps: ofs=0x00, nsteps=0x0f, stepsize=0x05, mute=1
  Amp-Out vals:  [0x80 0x80]
  Connection: 1
     0x0c
Node 0x0b [Audio Selector] wcaps 0x300105: Stereo Amp-Out
  Control: name="Line Out Playback Volume", index=0, device=0
    ControlAmp: chs=3, dir=Out, idx=0, ofs=0
  Control: name="Line Out Playback Switch", index=0, device=0
    ControlAmp: chs=3, dir=Out, idx=0, ofs=0
  Amp-Out caps: N/A
  Amp-Out vals:  [0x00 0x00]
  Connection: 1
     0x07
Node 0x0c [Audio Selector] wcaps 0x30010d: Stereo Amp-Out
  Control: name="Mic Boost Volume", index=0, device=0
    ControlAmp: chs=3, dir=Out, idx=0, ofs=0
  Amp-Out caps: ofs=0x00, nsteps=0x04, stepsize=0x27, mute=0
  Amp-Out vals:  [0x00 0x00]
  Connection: 5
     0x10 0x0f* 0x0e 0x0d 0x12
Node 0x0d [Pin Complex] wcaps 0x400181: Stereo
  Control: name="Headphone Jack", index=0, device=0
  Pincap 0x0000003f: IN OUT HP Detect Trigger ImpSense
  Pin Default 0x0321101f: [Jack] HP Out at Ext Left
    Conn = 1/8, Color = Black
    DefAssociation = 0x1, Sequence = 0xf
  Pin-ctls: 0xc0: OUT HP
  Unsolicited: tag=01, enabled=1
  Connection: 1
     0x0b
Node 0x0e [Pin Complex] wcaps 0x400181: Stereo
  Control: name="Speaker Phantom Jack", index=0, device=0
  Pincap 0x0000003f: IN OUT HP Detect Trigger ImpSense
  Pin Default 0x90170110: [Fixed] Speaker at Int N/A
    Conn = Analog, Color = Unknown
    DefAssociation = 0x1, Sequence = 0x0
    Misc = NO_PRESENCE
  Pin-ctls: 0x40: OUT
  Unsolicited: tag=00, enabled=0
  Connection: 1
     0x0b
Node 0x0f [Pin Complex] wcaps 0x400181: Stereo
  Control: name="Mic Phantom Jack", index=0, device=0
  Pincap 0x00000037: IN OUT Detect Trigger ImpSense
  Pin Default 0x90a70120: [Fixed] Mic at Int N/A
    Conn = Analog, Color = Unknown
    DefAssociation = 0x2, Sequence = 0x0
    Misc = NO_PRESENCE
  Pin-ctls: 0x20: IN
  Unsolicited: tag=00, enabled=0
  Connection: 1
     0x0b
Node 0x10 [Pin Complex] wcaps 0x400181: Stereo
  Control: name="Line Jack", index=0, device=0
  Pincap 0x00001737: IN OUT Detect Trigger ImpSense
    Vref caps: HIZ 50 GRD 80
  Pin Default 0x0381102e: [Jack] Line In at Ext Left
    Conn = 1/8, Color = Black
    DefAssociation = 0x2, Sequence = 0xe
  Pin-ctls: 0x20: IN VREF_HIZ
  Unsolicited: tag=03, enabled=1
  Connection: 1
     0x0b
Node 0x11 [Pin Complex] wcaps 0x400104: Mono Amp-Out
  Amp-Out caps: N/A
  Amp-Out vals:  [0x9f]
  Pincap 0x00000010: OUT
  Pin Default 0x40f000f2: [N/A] Other at Ext N/A
    Conn = Unknown, Color = Unknown
    DefAssociation = 0xf, Sequence = 0x2
  Pin-ctls: 0x00:
  Connection: 1
     0x13
Node 0x12 [Pin Complex] wcaps 0x400001: Stereo
  Pincap 0x00000020: IN
  Pin Default 0x40f000f3: [N/A] Other at Ext N/A
    Conn = Unknown, Color = Unknown
    DefAssociation = 0xf, Sequence = 0x3
  Pin-ctls: 0x20: IN
Node 0x13 [Audio Mixer] wcaps 0x200100: Mono
  Connection: 1
     0x07
Node 0x14 [Beep Generator Widget] wcaps 0x70000c: Mono Amp-Out
  Amp-Out caps: ofs=0x03, nsteps=0x03, stepsize=0x17, mute=1
  Amp-Out vals:  [0x83]
Codec: Conexant ID 2c06
Address: 1
MFG Function Id: 0x2 (unsol 1)
Vendor Id: 0x14f12c06
Subsystem Id: 0x14f1000f
Revision Id: 0x100000
Modem Function Group: 0x2
--endcollapse--


!!ALSA Device nodes
!!-----------------

crw-rw---- 1 root audio 116,  2 Jan 11 20:16 /dev/snd/controlC0
crw-rw---- 1 root audio 116,  4 Jan 11 20:17 /dev/snd/pcmC0D0c
crw-rw---- 1 root audio 116,  3 Jan 11 20:17 /dev/snd/pcmC0D0p
crw-rw---- 1 root audio 116,  1 Jan 11 20:16 /dev/snd/seq
crw-rw---- 1 root audio 116, 33 Jan 11 20:16 /dev/snd/timer

/dev/snd/by-path:
total 0
drwxr-xr-x 2 root root  60 Jan 11  2015 .
drwxr-xr-x 3 root root 160 Jan 11  2015 ..
lrwxrwxrwx 1 root root  12 Jan 11 20:16 pci-0000:00:1b.0 -> ../controlC0


!!Aplay/Arecord output
!!--------------------

APLAY

**** List of PLAYBACK Hardware Devices ****
card 0: Intel [HDA Intel], device 0: STAC9200 Analog [STAC9200 Analog]
  Subdevices: 1/1
  Subdevice #0: subdevice #0

ARECORD

**** List of CAPTURE Hardware Devices ****
card 0: Intel [HDA Intel], device 0: STAC9200 Analog [STAC9200 Analog]
  Subdevices: 1/1
  Subdevice #0: subdevice #0

!!Amixer output
!!-------------

!!-------Mixer controls for card 0 [Intel]

Card hw:0 'Intel'/'HDA Intel at 0xefebc000 irq 21'
  Mixer name	: 'SigmaTel STAC9200'
  Components	: 'HDA:83847690,10280201,00102201 HDA:14f12c06,14f1000f,00100000'
  Controls      : 17
  Simple ctrls  : 9
Simple mixer control 'Master',0
  Capabilities: pvolume pvolume-joined pswitch pswitch-joined
  Playback channels: Mono
  Limits: Playback 0 - 31
  Mono: Playback 31 [100%] [0.00dB] [on]
Simple mixer control 'PCM',0
  Capabilities: pvolume
  Playback channels: Front Left - Front Right
  Limits: Playback 0 - 255
  Mono:
  Front Left: Playback 255 [100%] [0.00dB]
  Front Right: Playback 255 [100%] [0.00dB]
Simple mixer control 'Line',0
  Capabilities: cswitch cswitch-joined cswitch-exclusive
  Capture exclusive group: 0
  Capture channels: Mono
  Mono: Capture [off]
Simple mixer control 'Line Out',0
  Capabilities: pvolume pswitch
  Playback channels: Front Left - Front Right
  Limits: Playback 0 - 31
  Mono:
  Front Left: Playback 0 [0%] [-99999.99dB] [on]
  Front Right: Playback 0 [0%] [-99999.99dB] [on]
Simple mixer control 'Mic',0
  Capabilities: cswitch cswitch-joined cswitch-exclusive
  Capture exclusive group: 0
  Capture channels: Mono
  Mono: Capture [on]
Simple mixer control 'Mic Boost',0
  Capabilities: volume
  Playback channels: Front Left - Front Right
  Capture channels: Front Left - Front Right
  Limits: 0 - 4
  Front Left: 0 [0%] [0.00dB]
  Front Right: 0 [0%] [0.00dB]
Simple mixer control 'Capture',0
  Capabilities: cvolume cswitch
  Capture channels: Front Left - Front Right
  Limits: Capture 0 - 15
  Front Left: Capture 0 [0%] [0.00dB] [off]
  Front Right: Capture 0 [0%] [0.00dB] [off]
Simple mixer control 'Auto-Mute Mode',0
  Capabilities: enum
  Items: 'Disabled' 'Enabled'
  Item0: 'Enabled'
Simple mixer control 'Digital',0
  Capabilities: cvolume
  Capture channels: Front Left - Front Right
  Limits: Capture 0 - 120
  Front Left: Capture 60 [50%] [0.00dB]
  Front Right: Capture 60 [50%] [0.00dB]


!!Alsactl output
!!--------------

--startcollapse--
state.Intel {
	control.1 {
		iface MIXER
		name 'Line Out Playback Volume'
		value.0 0
		value.1 0
		comment {
			access 'read write'
			type INTEGER
			count 2
			range '0 - 31'
			dbmin -9999999
			dbmax 0
			dbvalue.0 -9999999
			dbvalue.1 -9999999
		}
	}
	control.2 {
		iface MIXER
		name 'Line Out Playback Switch'
		value.0 true
		value.1 true
		comment {
			access 'read write'
			type BOOLEAN
			count 2
		}
	}
	control.3 {
		iface MIXER
		name 'Auto-Mute Mode'
		value Enabled
		comment {
			access 'read write'
			type ENUMERATED
			count 1
			item.0 Disabled
			item.1 Enabled
		}
	}
	control.4 {
		iface MIXER
		name 'Capture Source'
		value Mic
		comment {
			access 'read write'
			type ENUMERATED
			count 1
			item.0 Mic
			item.1 Line
		}
	}
	control.5 {
		iface MIXER
		name 'Capture Volume'
		value.0 0
		value.1 0
		comment {
			access 'read write'
			type INTEGER
			count 2
			range '0 - 15'
			dbmin 0
			dbmax 2250
			dbvalue.0 0
			dbvalue.1 0
		}
	}
	control.6 {
		iface MIXER
		name 'Capture Switch'
		value.0 false
		value.1 false
		comment {
			access 'read write'
			type BOOLEAN
			count 2
		}
	}
	control.7 {
		iface MIXER
		name 'Mic Boost Volume'
		value.0 0
		value.1 0
		comment {
			access 'read write'
			type INTEGER
			count 2
			range '0 - 4'
			dbmin 0
			dbmax 4000
			dbvalue.0 0
			dbvalue.1 0
		}
	}
	control.8 {
		iface MIXER
		name 'Master Playback Volume'
		value 31
		comment {
			access 'read write'
			type INTEGER
			count 1
			range '0 - 31'
			dbmin -9999999
			dbmax 0
			dbvalue.0 0
		}
	}
	control.9 {
		iface MIXER
		name 'Master Playback Switch'
		value true
		comment {
			access 'read write'
			type BOOLEAN
			count 1
		}
	}
	control.10 {
		iface CARD
		name 'Mic Phantom Jack'
		value true
		comment {
			access read
			type BOOLEAN
			count 1
		}
	}
	control.11 {
		iface CARD
		name 'Line Jack'
		value false
		comment {
			access read
			type BOOLEAN
			count 1
		}
	}
	control.12 {
		iface CARD
		name 'Headphone Jack'
		value false
		comment {
			access read
			type BOOLEAN
			count 1
		}
	}
	control.13 {
		iface CARD
		name 'Speaker Phantom Jack'
		value true
		comment {
			access read
			type BOOLEAN
			count 1
		}
	}
	control.14 {
		iface PCM
		name 'Playback Channel Map'
		value.0 0
		value.1 0
		comment {
			access read
			type INTEGER
			count 2
			range '0 - 36'
		}
	}
	control.15 {
		iface PCM
		name 'Capture Channel Map'
		value.0 0
		value.1 0
		comment {
			access read
			type INTEGER
			count 2
			range '0 - 36'
		}
	}
	control.16 {
		iface MIXER
		name 'PCM Playback Volume'
		value.0 255
		value.1 255
		comment {
			access 'read write user'
			type INTEGER
			count 2
			range '0 - 255'
			tlv '0000000100000008ffffec1400000014'
			dbmin -5100
			dbmax 0
			dbvalue.0 0
			dbvalue.1 0
		}
	}
	control.17 {
		iface MIXER
		name 'Digital Capture Volume'
		value.0 60
		value.1 60
		comment {
			access 'read write user'
			type INTEGER
			count 2
			range '0 - 120'
			tlv '0000000100000008fffff44800000032'
			dbmin -3000
			dbmax 3000
			dbvalue.0 0
			dbvalue.1 0
		}
	}
}
--endcollapse--


!!All Loaded Modules
!!------------------

Module


!!ALSA/HDA dmesg
!!--------------

[    0.688331] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[    0.692454] sound hdaudioC0D0: autoconfig: line_outs=1 (0xe/0x0/0x0/0x0/0x0) type:speaker
[    0.692472] sound hdaudioC0D0:    speaker_outs=0 (0x0/0x0/0x0/0x0/0x0)
[    0.692485] sound hdaudioC0D0:    hp_outs=1 (0xd/0x0/0x0/0x0/0x0)
[    0.692496] sound hdaudioC0D0:    mono: mono_out=0x0
[    0.692506] sound hdaudioC0D0:    inputs:
[    0.692516] sound hdaudioC0D0:      Mic=0xf
[    0.692526] sound hdaudioC0D0:      Line=0x10
[    0.693524] sound hdaudioC0D1: autoconfig: line_outs=0 (0x0/0x0/0x0/0x0/0x0) type:line
[    0.693541] sound hdaudioC0D1:    speaker_outs=0 (0x0/0x0/0x0/0x0/0x0)
[    0.693553] sound hdaudioC0D1:    hp_outs=0 (0x0/0x0/0x0/0x0/0x0)
[    0.693565] sound hdaudioC0D1:    mono: mono_out=0x0
[    0.693575] sound hdaudioC0D1:    inputs:
[    0.740585] ata1.00: ATA-6: TOSHIBA MK4009GAL, BS111G, max UDMA/100
--
[    4.552659]      nameserver0=10.10.0.1
[    4.561045] ALSA device list:
[    4.565218]   #0: HDA Intel at 0xefebc000 irq 21
[    4.924196] VFS: Mounted root (nfs filesystem) readonly on device 0:14.



--------------060202030607030805060701--
