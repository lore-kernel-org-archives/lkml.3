Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757750AbaKTS20 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 13:28:26 -0500
Received: from smtp2.tech.numericable.fr ([82.216.111.38]:39805 "EHLO
	smtp2.tech.numericable.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751406AbaKTS2Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 13:28:25 -0500
Message-ID: <546E32A5.4040202@laposte.net>
Date: Thu, 20 Nov 2014 19:27:49 +0100
From: Barto <mister.freeman@laposte.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: "Elliott, Robert (Server Storage)" <Elliott@hp.com>,
        Guenter Roeck <linux@roeck-us.net>, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: Re: BUG in scsi_lib.c due to a bad commit
References: <20141120060933.GA21432@infradead.org> <546E2880.5070303@laposte.net> <20141120175316.GA19590@infradead.org>
In-Reply-To: <20141120175316.GA19590@infradead.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejhedrkeekgddviecutefuodetggdotefrucfrrhhofhhilhgvmecupfgfoffgtffkveetuefngfenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurhepkfffhfgfggfvufhfjggtgfesthekrgdttdefheenucfhrhhomhepuegrrhhtohcuoehmihhsthgvrhdrfhhrvggvmhgrnheslhgrphhoshhtvgdrnhgvtheq
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

here is the result of the command :

$ for i in /sys/class/scsi_host/*; do cat $i/can_queue; done
1
1
1
1
1
1
31
31

but the sata DVD burner is now connected on a Jmicron sata PCIe card (
with this configuration the bug doesn't occur ), I don't know if this
change can modify the result of your command,

here is the result of another command :

$ for i in /sys/class/scsi_host/*; do cat $i/proc_name; done
pata_jmicron
pata_jmicron
ata_piix
ata_piix
ata_piix
ata_piix
ahci
ahci

$ dmesg | grep ahci
[    0.883351] ahci 0000:03:00.0: version 3.0
[    0.883505] ahci 0000:03:00.0: AHCI 0001.0100 32 slots 2 ports 3 Gbps
0x3 impl SATA mode
[    0.883508] ahci 0000:03:00.0: flags: 64bit ncq pm led clo pmp pio
slum part
[    0.884329] scsi host6: ahci
[    0.884502] scsi host7: ahci

Le 20/11/2014 18:53, Christoph Hellwig a écrit :
> On Thu, Nov 20, 2014 at 06:44:32PM +0100, Barto wrote:
>> I notice that my motherboard doesn't support "AHCI" mode, my motherboard
>> uses an ICH7 sata controler, ICH7 doesn't support AHCI if I check the
>> technical specifications of this controler,
>>
>> it seems that my bios treats SATA devices like IDE devices ( IDE
>> emulation mode ), for example I can read in the bios these lines "IDE 0
>> channel master : "the name of Sata harddisk 1", "IDE 3 channel master :
>> "the name of Sata harddisk 2",
>>
>> perhaps the bug only occurs when the AHCI mode is not used ?
> 
> Looks like it.  I suspect you device only supports a single outstanding
> command without AHCI, can you confirm this by doing:
> 
> for i in /sys/class/scsi_host/*; do cat $i/can_queue; done
> 
> 
