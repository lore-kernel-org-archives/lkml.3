Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756270Ab3AURXa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 12:23:30 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:64388 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754165Ab3AURXZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 12:23:25 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: "Russell King - ARM Linux" <linux@arm.linux.org.uk>
Subject: Re: [PATCH 02/33] ARM: Convert to devm_ioremap_resource()
Date: Mon, 21 Jan 2013 17:23:07 +0000
User-Agent: KMail/1.12.2 (Linux/3.7.0-7-generic; KDE/4.3.2; x86_64; ; )
Cc: Thierry Reding <thierry.reding@avionic-design.de>,
        linux-kernel@vger.kernel.org,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Wolfram Sang <w.sang@pengutronix.de>,
        linux-arm-kernel@lists.infradead.org
References: <1358762966-20791-1-git-send-email-thierry.reding@avionic-design.de> <20130121160547.GA10790@avionic-0098.adnet.avionic-design.de> <20130121161611.GS23505@n2100.arm.linux.org.uk>
In-Reply-To: <20130121161611.GS23505@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201301211723.07248.arnd@arndb.de>
X-Provags-ID: V02:K0:HSWfk6LPc51mvcd5mQ0MpOUAi0cVc4NZUU68BdVeQTk
 Rc7lzniZ1FdgCDz/CpC/uFBt0wFCa/SVpooILucVcz8rpRON8V
 sI/1qvFLWHf8OgfoVcZI3vLSlazgo2wkrQxjSeOwcVUZhujEvC
 GNsVGV8Vqx3Ln6Uo0Ca33Mv9cJEtC49K5aHOukSmcYgOSovnJ8
 mImWfKOJ5dqkvSKKpNGYVIIT/f6Rjbmp3o3DF05yx0tf4Dbue6
 kIVaUMmqS+JrOcfh777RWN7XRC0eZoVLD2SK+BhSuL/jgCRzFJ
 9INWwa9/4LTIIfkpfMwfPCBypnAswMP42+45hYr3G1G4P0Gpg/
 Kpr+yUwzj93WPjc7bc/Q=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 21 January 2013, Russell King - ARM Linux wrote:
> On Mon, Jan 21, 2013 at 05:05:47PM +0100, Thierry Reding wrote:
> > On Mon, Jan 21, 2013 at 03:58:46PM +0000, Russell King - ARM Linux wrote:
> > > On Mon, Jan 21, 2013 at 11:08:55AM +0100, Thierry Reding wrote:
> > > > Convert all uses of devm_request_and_ioremap() to the newly introduced
> > > > devm_ioremap_resource() which provides more consistent error handling.
> > > 
> > > Does this include the resource part of the handling too?
> > 
> > I'm not sure I understand your question. devm_ioremap_resource() does a
> > devm_request_mem_region() internally if that's what you were asking.
> 
> Ah, that's fine then.  The function name is a little misleading, and as
> it doesn't exist in mainline at present, it is not something I know about.

The usual problem with long patch series like this: The introductory mail
PATCH 0/xx explains this nicely, but it's not possible to put everyone
on Cc because then it gets rejected by vger for overly long mail headers.

We had a discussion about the function name earlier, but could not come
up with one that isn't too bulky but still carries the same meaning
as devm_request_and_ioremap() with a different symbol.

	Arnd
