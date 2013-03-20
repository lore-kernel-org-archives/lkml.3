Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755824Ab3CTPfN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 11:35:13 -0400
Received: from nm2.access.bullet.mail.sp2.yahoo.com ([98.139.44.129]:27448
	"EHLO nm2.access.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752151Ab3CTPfL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 11:35:11 -0400
X-Yahoo-Newman-Id: 632778.23094.bm@smtp110.biz.mail.gq1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: AOunqngVM1lKcsDmHhDspWuFZto.tg0B4GFfU5lqOCng86v
 xhpzO85uKtTBtbjxiVFhK9hg_c2HomcYsVN8c989ilGVL9AclnO.LYUM7u_6
 vY4mJ_ux03vAVQTgjnSQ6x9KNwJkKPFmaHUKRFxTkk45joKQeW2ESsIDdItk
 zYI_31j4coP0AeAAE3_H6dUQSRngh.bOwCVPQyhNs0nzshd_3.EK0wqwUEFM
 _9y6bqI00qgbsLxQVS7d6o.84XLViYdAjvLndLPyHKoQtI3BPpd86HV7YRW5
 os98u8daRDr2bg4Kuu_zhrB6yGgfhvWfoA.RkwtdP4MGKxaGaW9kUIuPeMEa
 y3BTc8D1BvR10UmrlALLDJTqsdHrsBYimt1cWIGFR3dITBVy1vJs3hKTzPHq
 q5y4G_7_3izz6xtCB_bAcxUkAN2YK9rTsiVvm2BdK66M3VKhfr8CdqblsFlN
 IEkd3HLqBvX6w28a9y_DiwlcmHnrYKU8-
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
X-Rocket-Received: from [192.168.0.103] (casey@50.131.111.212 with plain)
        by smtp110.biz.mail.gq1.yahoo.com with SMTP; 20 Mar 2013 08:35:10 -0700 PDT
Message-ID: <5149D737.6080409@schaufler-ca.com>
Date: Wed, 20 Mar 2013 08:35:19 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: tal.tchwella@gmail.com
CC: linux-kernel@vger.kernel.org, tchwella@mit.edu,
        Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [PATCH 0/3] Patches to enable chroot for all users
References: <1363784947-24060-1-git-send-email-tal.tchwella@gmail.com>
In-Reply-To: <1363784947-24060-1-git-send-email-tal.tchwella@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/20/2013 6:09 AM, tal.tchwella@gmail.com wrote:
> From: Tal Tchwella <tchwella@mit.edu>
>
> I want to suggest adding chroot capability to all users.

It is much too easy to create an environment for
tricking privileged programs using chroot to allow
unprivileged processes to use chroot. /etc/shadow
is your trivial attack surface.

> The following patches enable that capability, while considering the security mechanism needed to disable escape routes for chroots by non-root users,
> and keeping chroot backward-compatible for root users.
> The first patch establishes the concept of multi-user chroot, while disabling checks for root user in the chroot process.
> The second patch checks whether a fd that is sent to a chroot application by a non-root user refers to a directory. 
> If that is the case, that fd is skipped, to disable an escape route. 
> The third patch disables the option for applications that have open fds to directories to be chrooted by a non-root user.
>
> These patches were applied and test on linux-kernel 3.2.0-31-generic.
>
> Any comments, feedback and suggestions are appreciated!
>
> Thanks,
> Tal
>
>
> Tal Tchwella (3):
>   enabled chroot for all users
>   socket checks for uds fds transfer
>   open fds check when starting chroot
>
>  fs/exec.c             |    3 +++
>  fs/open.c             |   32 ++++++++++++++++++++++++++++++--
>  include/linux/sched.h |   12 ++++++++++++
>  init/main.c           |    1 +
>  kernel/fork.c         |    2 ++
>  net/core/scm.c        |    9 +++++++++
>  6 files changed, 57 insertions(+), 2 deletions(-)
>

