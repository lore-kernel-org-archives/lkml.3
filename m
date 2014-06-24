Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754069AbaFXOwJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 10:52:09 -0400
Received: from mail-ig0-f173.google.com ([209.85.213.173]:42550 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753918AbaFXOwG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 10:52:06 -0400
Date: Tue, 24 Jun 2014 15:51:53 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Kishon Vijay Abraham I <kishon@ti.com>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        devicetree <devicetree@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] phy: miphy365x: Add Device Tree bindings for the
 MiPHY365x
Message-ID: <20140624145153.GQ13803@lee--X1>
References: <1400766819-22286-1-git-send-email-lee.jones@linaro.org>
 <6599289.0ZjjaMbRqj@wuerfel>
 <20140624124634.GO13803@lee--X1>
 <4274516.nCpbjAuUJp@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4274516.nCpbjAuUJp@wuerfel>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Jun 2014, Arnd Bergmann wrote:
> On Tuesday 24 June 2014 13:46:34 Lee Jones wrote:
> > > > > > converting all addresses to to resources so drivers can easily pull
> > > > > > them out using platform_get_resource() and friends.  Pushing the reg
> > > > > 
> > > > > right. Can't we use of_address_to_resource here?
> > > > 
> > > > We could, but that would be an extra layer.  We'd be pulling the
> > > > address, putting it into a resource, then pulling it from the resource
> > > > for use.  If we're going to be pulling addresses out manually, we're
> > > > probably better off using of_get_address().  But again, we're just
> > > > carrying out functionality which is already provided by the
> > > > framework.
> > > 
> > > there is also of_ioremap().
> > 
> > Isn't this SPARK only?  And doesn't it require a populated resource?  
> > Which is what I'm saying is the issue here i.e. we don't have one.
> 
> Sorry, I meant of_iomap(). I think it's only for historic reaons
> that we have both. Probably of_iomap started out on powerpc with
> the same intention as the sparc of_ioremap.
> 
> of_iomap does not require a resource, just an index.

Ah, this sounds like a better solution.  I'll have a play, thanks.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
