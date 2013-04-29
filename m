Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760047Ab3EAWsa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 18:48:30 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:9845 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759928Ab3EAWs1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 18:48:27 -0400
X-Authority-Analysis: v=2.0 cv=cOZiQyiN c=1 sm=0 a=tLUlnkoJZcZI9ocdGARlSQ==:17 a=c11ml42nfjYA:10 a=wom5GMh1gUkA:10 a=0-XA48YcNiwA:10 a=Rj1_iGo3bfgA:10 a=kj9zAlcOel0A:10 a=hBqU3vQJAAAA:8 a=2Ve8rObJkNIA:10 a=xkGCmgZVAAAA:8 a=Ud8Re2wkNlNuPFzoAZgA:9 a=CjuIK1q_8ugA:10 a=aZ5k6lslHxgA:10 a=tLUlnkoJZcZI9ocdGARlSQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 70.114.148.7
Date: Mon, 29 Apr 2013 15:56:28 -0500
From: "Serge E. Hallyn" <serge@hallyn.com>
To: shea@shealevy.com
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        linux-kernel@vger.kernel.org
Subject: Re: Linux 3.8.9 Build Failure in user_namespace.c
Message-ID: <20130429205628.GA20607@austin.hallyn.com>
References: <af928063831e8eabf1236448484a8a9f@shealevy.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <af928063831e8eabf1236448484a8a9f@shealevy.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting shea@shealevy.com (shea@shealevy.com):
> Hi All,
> 
> I just hit the following error trying to build 3.8.9:
> 
> /nix/store/vkvwpn6f7iff6zqrq2d9z2a1945pcsza-linux-3.8.9-source/kernel/user_namespace.c:
> In function 'map_write':
> /nix/store/vkvwpn6f7iff6zqrq2d9z2a1945pcsza-linux-3.8.9-source/kernel/user_namespace.c:582:2:
> error: implicit declaration of function 'file_ns_capable'
> [-Werror=implicit-function-declaration]
> cc1: some warnings being treated as errors
> 
> Below is my .config, below that the build log.

I'm looking at 3.9.  file_ns_capable() is declared in capability.h, which gets
included into user_namespace.c through cred.h.  I did also try building with
CONFIG_SECURITY=n and CONFIG_USER_NS=y as you have it, but build succeeded,
as I would expect given how it is included.

Do you have any custom patches applied by chance?

-serge
