Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755450Ab3IYMuH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 08:50:07 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:53620 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755182Ab3IYMuD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 08:50:03 -0400
X-AuditID: cbfee61a-b7f7a6d00000235f-89-5242dbf930f2
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Roger Quadros <rogerq@ti.com>
Cc: balbi@ti.com, bcousson@baylibre.com, tony@atomide.com, balajitk@ti.com,
        kishon@ti.com, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Tejun Heo <tj@kernel.org>
Subject: Re: [RFC PATCH 09/15] ata: ti_sata: Add Texas Instruments SATA Wrapper
 driver
Date: Wed, 25 Sep 2013 14:49:56 +0200
Message-id: <3930265.gHe05HETI5@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-52-generic-pae; KDE/4.8.5; i686; ; )
In-reply-to: <5608096.0pgFIteLqQ@amdc1032>
References: <1379595943-14622-1-git-send-email-rogerq@ti.com>
 <1379595943-14622-10-git-send-email-rogerq@ti.com>
 <5608096.0pgFIteLqQ@amdc1032>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=ISO-8859-1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrBLMWRmVeSWpSXmKPExsVy+t9jAd2ft52CDJ7M1baYOnk7m8XB+/UW
	d+b/ZbWYf+Qcq8WFpz1sFpseX2O1OLbjEZPF5V1z2CxmL+lnseh5pGXxa/lRRov9V7wceDy+
	fZ3E4vH+Riu7x6ZVnWwem5fUexy/sZ3J4/MmuQC2KC6blNSczLLUIn27BK6MQy1v2Qt+sVX8
	WPSJsYHxLGsXIyeHhICJxI1zk9khbDGJC/fWs3UxcnEICSxilNi2aTkLhNPCJHGnZTYTSBWb
	gJXExPZVjCC2iICixL2VEB3MApOZJHb9vA42VlggQmLT9WY2EJtFQFVi/++lYCt4BTQlmjbO
	BouLCnhKfJq0lBnE5hTQkng85TTU6kmMEhPnNDJCNAhK/Jh8jwXEZhaQl9i3fyorhK0jsb91
	GtsERoFZSMpmISmbhaRsASPzKkbR1ILkguKk9FxDveLE3OLSvHS95PzcTYzg+HgmtYNxZYPF
	IUYBDkYlHl6Bo45BQqyJZcWVuYcYJTiYlUR4+687BQnxpiRWVqUW5ccXleakFh9ilOZgURLn
	PdBqHSgkkJ5YkpqdmlqQWgSTZeLglGpg3Lg03bEy9/9MLoEju/a2fTjydJ4Lp6H//rr7Z0/0
	qfkvFXrkt9dthzffsteXVRXzohkLF4pHifjKsb0R+nFkW9WXjZJq3Ik/jaQVDmYaNsfmaSQU
	FeZbzzQ97n+Wyzbs06W2bk1nzaolZcd3Kk41nPhA+T/bO5GE+x1nby/a5PX2jpjJ/dQPSizF
	GYmGWsxFxYkAj2+4uosCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, September 25, 2013 02:37:19 PM Bartlomiej Zolnierkiewicz wrote:

[...]

> > +#ifdef CONFIG_PM
> > +
> > +static int ti_sata_resume(struct device *dev)
> > +{
> > +	pm_runtime_disable(dev);
> > +	pm_runtime_set_active(dev);
> > +	pm_runtime_enable(dev);
> 
> This doesn't look like a correct ->resume method:
> * it shouldn't touch runtime PM at all
> * for each ->resume method there should be a corresponding ->suspend method
> 
> Moreover this whole wrapper driver seems strange, why not just add a proper
> runtime PM support to ahci_platform driver instead?

Hmm, even this shouldn't be needed as this wrapper driver doesn't have
->runtime_suspend and ->runtime resume methods.

What exactly is the purpose of the existence of this wrapper driver?

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

