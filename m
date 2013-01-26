Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754086Ab3AZNsv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2013 08:48:51 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:49874 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751019Ab3AZNss (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2013 08:48:48 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 14/14] idr: deprecate idr_remove_all()
Date: Sat, 26 Jan 2013 13:48:35 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-1-generic; KDE/4.3.2; x86_64; ; )
Cc: akpm@linux-foundation.org, rusty@rustcorp.com.au,
        linux-kernel@vger.kernel.org
References: <1359163872-1949-1-git-send-email-tj@kernel.org> <1359163872-1949-15-git-send-email-tj@kernel.org>
In-Reply-To: <1359163872-1949-15-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201301261348.36135.arnd@arndb.de>
X-Provags-ID: V02:K0:qxpWvEGs/4S3k4sa7vRgtNRG7v5EDZUvhQeZ1HHKg90
 Ri36LaA9BZNLkWLQ6Sw92DPcRvM0UCLjbMglR6Gr2AMMTnchjI
 34gSSiOFCpfLoIpsByN5fjvb8+VqoGq3pkIyQfzxGqcDhdYXBf
 dFwMyA9Tl4d6U122PHXoEi86DlnEQRwh97R+zOw8I1JdT40ern
 oHumm3GzMJ42PbAFWSTYg3yzC3rM+2Kg/HPEi3ID+e7Ugper2A
 /Igv3R2poAm08NOpSek+cX03chWwE2vWyzUnVCNl8fl/V4hnvY
 eue7zoEKxt3yP9TMeR4IfSjrywkQce6qSUODL1u9DdgEuXDMkv
 UInyBt/nVdb2h5MDbOi8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 26 January 2013, Tejun Heo wrote:
> 
> There was only one legitimate use of idr_remove_all() and a lot more
> of incorrect uses (or lack of it).  Now that idr_destroy() implies
> idr_remove_all() and all the in-kernel users updated not to use it,
> there's no reason to keep it around.  Mark it deprecated so that we
> can later unexport it.
> 
> idr_remove_all() is made an inline function calling __idr_remove_all()
> to avoid triggering deprecated warning on EXPORT_SYMBOL().
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>

If all in-kernel users are gone, why not just remove the function
completely?

	Arnd
