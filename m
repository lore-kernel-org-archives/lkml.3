Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752770AbaAMToR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 14:44:17 -0500
Received: from smtp103.biz.mail.bf1.yahoo.com ([98.139.221.62]:35751 "HELO
	smtp103.biz.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752734AbaAMToJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 14:44:09 -0500
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: bGVt2KgVM1kxq7e4.YgyZ7_R9R4yZsqaW3Dg7fxudixV71W
 PzZTQsPouuwUqG1CTV7eQq5FYaYxrLX2nDwXrQFCbz4_c2yeO2R.TRilz89C
 azvb61uyo0OZLconVy_M_dFdKts2YibczvLSLNuHuN91b.IbWJTOF4dk7mO.
 m9lT7q.0T3Rxy_LvGX6Ch2YA7FOoqYrwKaLGZkbPf40fxG5vxQ25vpXKcpt8
 DHc04Uo.S1sV9UJraMEwIOfCr5MTyOUmDIWEL1XGxia6QgRDdvPAr2.SI_de
 XhczP1ISUKb4BLMTolTDsbOJ_5MruRbIsEIAGcNZyxSwqnrGo_kBPkUiI6n0
 R_JW9xAS_cqgWaKO70yeM4b.hTGzQfqkh4HWXVVBj998zcQw.Nix3XctV3Jq
 br4QH.zh6Pf.q21Lbza2Mjejtv.jwWNwsDMSjXy04dtih.Qhl6RT_m10VUXl
 TH68pNRdH2kTgtPp9_7xSpcJq_KeFHnuYN3Lz2I9e1jtwsClCbrmX1eRGexU
 rBf7nQUrnP2G9xBTvB52t3K3pWIm_wYDPuxX86anyL4Tj
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
X-Rocket-Received: from [192.168.0.105] (casey@67.180.103.242 with plain [98.139.221.242])
        by smtp103.biz.mail.bf1.yahoo.com with SMTP; 13 Jan 2014 11:44:08 -0800 PST
Message-ID: <52D44206.2000906@schaufler-ca.com>
Date: Mon, 13 Jan 2014 11:44:06 -0800
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Jan Kaluza <jkaluza@redhat.com>, davem@davemloft.net
CC: LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
        eparis@redhat.com, rgb@redhat.com, tj@kernel.org, lizefan@huawei.com,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        viro@zeniv.linux.org.uk
Subject: Re: [PATCH v4 0/3] Send audit/procinfo/cgroup data in socket-level
 control message
References: <1377614400-27122-1-git-send-email-jkaluza@redhat.com> <1389600109-30739-1-git-send-email-jkaluza@redhat.com>
In-Reply-To: <1389600109-30739-1-git-send-email-jkaluza@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/13/2014 12:01 AM, Jan Kaluza wrote:
> Hi,
>
> this patchset against net-next (applies also to linux-next) adds 3 new types
> of "Socket"-level control message (SCM_AUDIT, SCM_PROCINFO and SCM_CGROUP).

How about the group list, while you're at it?

>
> Server-like processes in many cases need credentials and other
> metadata of the peer, to decide if the calling process is allowed to
> request a specific action, or the server just wants to log away this
> type of information for auditing tasks.
>
> The current practice to retrieve such process metadata is to look that
> information up in procfs with the $PID received over SCM_CREDENTIALS.
> This is sufficient for long-running tasks, but introduces a race which
> cannot be worked around for short-living processes; the calling
> process and all the information in /proc/$PID/ is gone before the
> receiver of the socket message can look it up.
>
> Changes introduced in this patchset can also increase performance
> of such server-like processes, because current way of opening and
> parsing /proc/$PID/* files is much more expensive than receiving these
> metadata using SCM.
>
> Changes in v4:
> - Rebased to work with the latest net-next tree
>
> Changes in v3:
> - Better description of patches (Thanks to Kay Sievers)
>
> Changes in v2:
> - use PATH_MAX instead of PAGE_SIZE in SCM_CGROUP patch
> - describe each patch individually
>
> Jan Kaluza (3):
>   Send loginuid and sessionid in SCM_AUDIT
>   Send comm and cmdline in SCM_PROCINFO
>   Send cgroup_path in SCM_CGROUP
>
>  include/linux/socket.h |  9 ++++++
>  include/net/af_unix.h  | 10 ++++++
>  include/net/scm.h      | 67 ++++++++++++++++++++++++++++++++++++++--
>  net/core/scm.c         | 83 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  net/unix/af_unix.c     | 70 ++++++++++++++++++++++++++++++++++++++++++
>  5 files changed, 237 insertions(+), 2 deletions(-)
>

