Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751319AbaJBJOv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 05:14:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64623 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750919AbaJBJOt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 05:14:49 -0400
Message-ID: <542D1726.3040801@draigBrady.com>
Date: Thu, 02 Oct 2014 10:13:10 +0100
From: =?ISO-8859-1?Q?P=E1draig_Brady?= <P@draigBrady.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Yann Droneaud <ydroneaud@opteya.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Heinrich Schuchardt <xypron.glpk@gmx.de>,
        Eric Paris <eparis@redhat.com>, Richard Guy Briggs <rgb@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, stable@vger.kernel.org,
        linux-api@vger.kernel.org, Jan Kara <jack@suse.cz>,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>,
        Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        Michael Kerrisk-manpages <mtk.manpages@gmail.com>
Subject: Re: [PATCH] fanotify: add a flag to allow setting O_CLOEXEC on event
 fd
References: <cover.1411562410.git.ydroneaud@opteya.com> <9d050a2db4f9cf68cd6cb038f16cccb0f73c6e66.1411562410.git.ydroneaud@opteya.com> <542481B3.8070300@gmx.de> <1411721898.7778.18.camel@localhost.localdomain> <542666B2.9080700@gmx.de> <1411980555-10818-1-git-send-email-ydroneaud@opteya.com> <20141001153621.65e9258e65a6167bf2e4cb50@linux-foundation.org> <1412230855.28184.5.camel@localhost.localdomain> <1412236349-30035-1-git-send-email-ydroneaud@opteya.com>
In-Reply-To: <1412236349-30035-1-git-send-email-ydroneaud@opteya.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/02/2014 08:52 AM, Yann Droneaud wrote:
> In order to not potentially break applications which were
> requesting O_CLOEXEC on event file descriptors but which
> actually need it to be not effective as the kernel currently
> ignore the flag, so the file descriptor is inherited accross
> exec regardless of O_CLOEXEC (please forgive me for the
> wording), this patch introduces FAN_FD_CLOEXEC flag to
> fanotify_init() so that application can request O_CLOEXEC
> to be effective.
> Newer application would use FAN_FD_CLOEXEC flag along
> O_CLOEXEC to enable close on exec on newly created
> file descriptor:
> 
>   fd = fanotify_init(FAN_CLOEXEC|FAN_NONBLOCK|FAN_FD_CLOEXEC,
>                      O_RDONLY|O_LARGEFILE|O_CLOEXEC|O_NOATIME);

Ugh really?
IMHO there should be widespread or at least known breakage with
O_CLOEXEC before adding messiness like this.
It seems surprising to me that apps that would depend on
O_CLOEXEC being ineffective.

please reconsider this one.

thanks,
Pádraig.

