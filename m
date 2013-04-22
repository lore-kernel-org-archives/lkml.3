Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753254Ab3DVUwz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 16:52:55 -0400
Received: from mail.pr.hu ([87.242.0.5]:58674 "EHLO mail.pr.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751210Ab3DVUwy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 16:52:54 -0400
Message-ID: <5175A30F.2000906@pr.hu>
Date: Mon, 22 Apr 2013 22:52:31 +0200
From: Boszormenyi Zoltan <zboszor@pr.hu>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130402 Thunderbird/17.0.5
MIME-Version: 1.0
To: Aaron Lu <aaron.lwe@gmail.com>
CC: lkml <linux-kernel@vger.kernel.org>, Jeff Garzik <jgarzik@pobox.com>,
        linux-ide@vger.kernel.org
Subject: Re: ahci driver cannot suspend a CF card, ata_piix can
References: <516D3CEF.6010202@pr.hu> <51715F5C.3050502@gmail.com>
In-Reply-To: <51715F5C.3050502@gmail.com>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Score: -2.1 (--)
X-Scan-Signature: 7572fbe1482f51d378d5cb517c4344f1
X-Spam-Tracer: backend.mail.pr.hu -2.1 20130422205042Z
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2013-04-19 17:14 keltezéssel, Aaron Lu írta:
> On 04/16/2013 07:58 PM, Boszormenyi Zoltan wrote:
>> Hi,
>>
>> The SATA interface can be switched between AHCI and legacy modes as usual:
>>
>> 00:1f.2 SATA controller: Intel Corporation NM10/ICH7 Family SATA
>> Controller [AHCI mode] (rev 02)
>>
>> The device attached to the SATA controller is always a CF card via a
>> SiI3811 Serial ATA to Parallel ATA Device Bridge based converter board.
>
> Can you please attach a normal sata disk and try again with the
> controller set to AHCI mode? I suspect it may be the SiI3811 bridge that
> caused this command.

I have finally got around to testing a different beast, a Zotax ZBOX with
mostly the same motherboard components that the previously mentioned
embedded PC had. It turned out that this embedded PC (a POS machine)
doesn't have regular SATA connectors but a special one to connect only
this SATA-EIDE converter card with the SiI3811 chip.

Anyway, using the Zotac box, both a shiny new Samsung 840 SSD
and a CF card using a different IDE bridge chip (Sunplus SATALink SPIF223A)
can suspend to RAM using AHCI mode.

Your suspicion turned out to be correct.

Best regards,
Zoltán Böszörményi

