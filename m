Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753010AbaKXPNY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 10:13:24 -0500
Received: from smtp1.tech.numericable.fr ([82.216.111.37]:33530 "EHLO
	smtp1.tech.numericable.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750733AbaKXPNW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 10:13:22 -0500
Message-ID: <54734AEA.7010102@laposte.net>
Date: Mon, 24 Nov 2014 16:12:42 +0100
From: Barto <mister.freeman@laposte.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: "Elliott, Robert (Server Storage)" <Elliott@hp.com>,
        Guenter Roeck <linux@roeck-us.net>, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: BUG in scsi_lib.c due to a bad commit
References: <20141120060933.GA21432@infradead.org> <546E2880.5070303@laposte.net> <20141120175316.GA19590@infradead.org> <546E32A5.4040202@laposte.net> <20141124091835.GA21579@infradead.org>
In-Reply-To: <20141124091835.GA21579@infradead.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejhedrleeigdehkecutefuodetggdotefrucfrrhhofhhilhgvmecupfgfoffgtffkveetuefngfenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurhepkfffhfgfggfvufhfjggtgfesthekrgdttdefheenucfhrhhomhepuegrrhhtohcuoehmihhsthgvrhdrfhhrvggvmhgrnheslhgrphhoshhtvgdrnhgvtheqnecuffhomhgrihhnpehkvghrnhgvlhdrohhrgh
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Christoph,

to be clear :

my JMicron pcie card JMB363/368 has 2 sata ports and one IDE port,
JMicron supports AHCI on these 2 sata ports,

my gigabyte motherboard has 4 sata ports and one IDE port, my gigabyte
motherboard doesn't support AHCI on these 4 sata ports ( my bios seems
to treats sata devices like IDE devices, a kind of "IDE emulation mode" ),

the bug doesn't occur if the Sata DVD burner is not mixed with a hard
disk on the  Sata ports ( motherboard sata ports ),

the configuration who triggers the bug is mixing a slow device ( sata
dvd burner ) with a fast device ( sata harddisk ) on the sata ports of
the motherboard ( who doesn't support AHCI ),

the bug doesn't occur if the sata dvd burner is connected on a JMicron
pcie card because there is no other sata harddisks connected on this
JMicron, I connect only a IDE hardidsk on this JMicron pcie card and
also this Sata dvd burner in order to avoid the bug ( it's a workaround ),

2 pata_jmicron = the IDE port in this JMicron pcie card ( master and slave )
4 ata_piix = 4 sata ports from the gigabyte motherboard, this ports
doesn't support AHCI
2 ahci = 2 sata ports in this JMicron pcie card

but another user has the same problem but with an IDE DVD burner ( mixed
with an IDE hardidsk ) :

https://bugzilla.kernel.org/show_bug.cgi?id=87581#c18

this user has tested your patch and it solves the bug


Le 24/11/2014 10:18, Christoph Hellwig a écrit :
> On Thu, Nov 20, 2014 at 07:27:49PM +0100, Barto wrote:
>> but the sata DVD burner is now connected on a Jmicron sata PCIe card (
>> with this configuration the bug doesn't occur ), I don't know if this
>> change can modify the result of your command,
>>
>> here is the result of another command :
>>
>> $ for i in /sys/class/scsi_host/*; do cat $i/proc_name; done
>> pata_jmicron
>> pata_jmicron
>> ata_piix
>> ata_piix
>> ata_piix
>> ata_piix
>> ahci
>> ahci
> 
> Interesting.  So the jmicron card also has a queue depth of just one,
> but the error still occurs?  I've added the linux-ide list, maybe
> someone there has an idea how piix vs jmicron could have such different
> behaviors for queueing or error handling.
> 
> 
