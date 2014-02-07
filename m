Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752039AbaBGKjp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 05:39:45 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:50797 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751068AbaBGKjn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 05:39:43 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Roger Quadros <rogerq@ti.com>
Cc: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>, kishon@ti.com,
        Tejun Heo <tj@kernel.org>, balbi@ti.com, bcousson@baylibre.com,
        tony@atomide.com, balajitk@ti.com, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Hans de Goede <hdegoede@redhat.com>
Subject: Re: [RFC PATCH 08/15] ata: ahci_platform: Manage SATA PHY
Date: Fri, 07 Feb 2014 11:39:03 +0100
Message-ID: <463926864.ALblgUKdgH@wuerfel>
User-Agent: KMail/4.11.3 (Linux/3.11.0-15-generic; KDE/4.11.3; x86_64; ; )
In-Reply-To: <52F4B682.2000201@ti.com>
References: <1379595943-14622-1-git-send-email-rogerq@ti.com> <5240492D.6060204@ti.com> <52F4B682.2000201@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:Cjb87jOFoEfZ0zE3peceIgyQxf9LtFoAcjrLNMNxm3X
 4RNZW1uVCHmaEmS+QTepk2iaT9Ek52guUPO6Kt6Fx2jwJtldYE
 w8H6WGpFKiazQTWoD/RR3EjkcdY6n3KIxbFObzpAxNzDzaNqKK
 bll8gNKaWBYaetB6hwg4WL0gjLcy/xLDOdUm+Y6GwwKUwjHLac
 BfxZ7m/wzBujH7TG/qMZUKwRlaL1qrTOci9KTrZIPJK6f3w9sr
 Jnb0wJTZCalDtCwBWNdS0I3Z+nvNoXRgtith/jg0qnV574yyT1
 5m9aoT9MPFJjk7498m1Iw44T0KoSArG9rblLYxIxYKTzOxiFak
 VU9ELgH7F5cn5VWSNqN0=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 07 February 2014 12:33:38 Roger Quadros wrote:
> 
> This means we need to make CONFIG_SATA_AHCI_PLATFORM depend on CONFIG_GENERIC_PHY or
> select it.
> 
> OR
> 
> Generic PHY layer must be fixed so that the API's are always built in.
> 
> What is the better option? I believe making the PHY API's always built in is the better option.
> 

CONFIG_SATA_AHCI_PLATFORM should do

	"depends on CONFIG_GENERIC_PHY || !CONFIG_GENERIC_PHY"

which is the Kconfig way of saying that if CONFIG_GENERIC_PHY is a module,
CONFIG_SATA_AHCI_PLATFORM needs to be a module as well.

	Arnd
