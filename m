Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753078AbaFXOIU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 10:08:20 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:60705 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751401AbaFXOIS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 10:08:18 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Lee Jones <lee.jones@linaro.org>
Cc: Kishon Vijay Abraham I <kishon@ti.com>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        devicetree <devicetree@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] phy: miphy365x: Add Device Tree bindings for the MiPHY365x
Date: Tue, 24 Jun 2014 16:08:15 +0200
Message-ID: <4274516.nCpbjAuUJp@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140624124634.GO13803@lee--X1>
References: <1400766819-22286-1-git-send-email-lee.jones@linaro.org> <6599289.0ZjjaMbRqj@wuerfel> <20140624124634.GO13803@lee--X1>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:YvWSh+ixZRpNdtM0CkbVXNFisU/9UyWqet8IyMuklGb
 qrhTy7pe2HVAxlntrd+US2AaoMzNWU5KFJPiYB5riBJpAcdxji
 WErFFjNnVWVSU/A6BXMwjJu4svpkZks7/7msaER+KnsrZ665Yr
 I+h8+8ayX95+oI+FB4mIWzXfk47HhPrzHu5c5CmuI6iOrkdoVQ
 9Vr7i0b5yxNMvUfbH0EEJ/bodHN7IDrt+aAOU4S7IkLNv4hMg8
 1qKEwR5M2ONitJwqVUPYOQp+RQKszymvaEbtMGwlzJJPJIo6gP
 bZOZxm5fnxaaVMSIGbjf8+t+nvrwaevWtly4ecC93WxyVDZS4h
 gsrHXLL7qE4cEiYZkVo4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 24 June 2014 13:46:34 Lee Jones wrote:
> > > > > converting all addresses to to resources so drivers can easily pull
> > > > > them out using platform_get_resource() and friends.  Pushing the reg
> > > > 
> > > > right. Can't we use of_address_to_resource here?
> > > 
> > > We could, but that would be an extra layer.  We'd be pulling the
> > > address, putting it into a resource, then pulling it from the resource
> > > for use.  If we're going to be pulling addresses out manually, we're
> > > probably better off using of_get_address().  But again, we're just
> > > carrying out functionality which is already provided by the
> > > framework.
> > 
> > there is also of_ioremap().
> 
> Isn't this SPARK only?  And doesn't it require a populated resource?  
> Which is what I'm saying is the issue here i.e. we don't have one.

Sorry, I meant of_iomap(). I think it's only for historic reaons
that we have both. Probably of_iomap started out on powerpc with
the same intention as the sparc of_ioremap.

of_iomap does not require a resource, just an index.

	Arnd
