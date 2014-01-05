Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751673AbaAESLw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jan 2014 13:11:52 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:53748 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751293AbaAESLu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jan 2014 13:11:50 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Ravi Patel <rapatel@apm.com>
Subject: Re: [PATCH V2 0/4] misc: xgene: Add support for APM X-Gene SoC Queue Manager/Traffic Manager
Date: Sun, 5 Jan 2014 19:11:12 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Greg KH <gregkh@linuxfoundation.org>, Loc Ho <lho@apm.com>,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Jon Masters <jcm@redhat.com>, "patches@apm.com" <patches@apm.com>,
        Keyur Chudgar <kchudgar@apm.com>
References: <1387594651-25771-1-git-send-email-rapatel@apm.com> <1441245.xPZLG2iNZ6@wuerfel> <CAN1v_PtFz42crHW5=cUgw-fAnPn3rQht=o0t3nmjJRamYSLDMg@mail.gmail.com>
In-Reply-To: <CAN1v_PtFz42crHW5=cUgw-fAnPn3rQht=o0t3nmjJRamYSLDMg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201401051911.12349.arnd@arndb.de>
X-Provags-ID: V02:K0:PP7xMFdDXfh2kQYsoBSGIi+7C2QdzbCtMiqaU1xKVQH
 Rrch6P18VSn8CmM124abSHrjCPl9DUn9/BfthZTr2q7ZGm3Ex0
 wXuEJ+lGbnXi4H5zz3mgQAUdjNkyV9ztYSfYzjW0QlWXfOxcxn
 LezpxUcntfeT1nXeV/UmFakTbs9mj4LQk90tiqquV44wxrPLSF
 kGJDiRlucS6QhzRyCgcYX0JKNqDcZBvL+OflFhtQQawcu2etQn
 IEi0f6WkCGnfzpAW5n+crEhayoJXKwDYUlr7FdSiPq5k9cO81f
 gMBDNbeoB7cb5CdgoJcPAqEZ1iZvzsoVL3rz4ZK95q3SKMIHhs
 CtVvvpPdWrfboz+QrH/M=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 05 January 2014, Ravi Patel wrote:
> On Sat, Dec 21, 2013 at 11:03 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> > On Saturday 21 December 2013 17:00:51 Loc Ho wrote:
> >> On Sat, Dec 21, 2013 at 12:11 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> >
> > Please describe here what the purpose of the qmtm is, as this is not
> > entirely clear from the code or from your reply.
> >
> > Greg was guessing that it's a bus controller, my best guess is a DMA
> > engine. If it's something completely different, you have to let
> > us know what it is so we can do a proper review rather than guessing.
> >
> > Please provide a link to the data sheet if you are unable to explain.
> 
> Here is URL to a text document explaining role of QMTM device with CPU, Ethernet
> subsystem.
> 
> https://drive.google.com/file/d/0B28TgQZ3JLoRRGNnbjJoUGNHWW8/edit?usp=sharing
> 
> For simplicity, I have shown only Ethernet.
> PktDMA and Security subsystem interfaces with QMTM in the same way as Ethernet.
> 

Thanks, that helps a lot. Please add this file to an appropriate place
in the Documentation directory in the next version of your patches.

There is still one central aspect that remains unclear to me, which is
what the QMTM is actually good for, as opposed to how it gets used from
the OS. In the text description, it sounds like the ethernet is the DMA
master and performs DMA all by itself but from that it's not clear why
a message to and from the QMTM is needed. From your drawing on the other
hand, it seems like the QMTM is really the DMA master and performs the
DMA on behalf of the ethernet device, which isn't connected to the
coherent interface itself. If this is correct, it seems that QMTM is more
like a DMA engine after all that should use the existing slave API to
provide services to slave drivers.

	Arnd
