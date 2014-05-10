Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752176AbaEJP4N (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2014 11:56:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21812 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750780AbaEJP4L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2014 11:56:11 -0400
Message-ID: <1399737362.3558.22.camel@localhost>
Subject: Re: [PATCH V2 2/6] audit: log namespace serial numbers
From: Eric Paris <eparis@redhat.com>
To: Richard Guy Briggs <rgb@redhat.com>
Cc: linux-audit@redhat.com, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org, arozansk@redhat.com,
        serge@hallyn.com, ebiederm@xmission.com, sgrubb@redhat.com
Date: Sat, 10 May 2014 11:56:02 -0400
In-Reply-To: <e1b3ea66770e9e8d067c4fb725a6940c41ccf2f2.1399681022.git.rgb@redhat.com>
References: <cover.1399681022.git.rgb@redhat.com>
	 <e1b3ea66770e9e8d067c4fb725a6940c41ccf2f2.1399681022.git.rgb@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-05-09 at 20:27 -0400, Richard Guy Briggs wrote:

Not so relevant because you delete all of this code later...  But
still...

> +#ifdef CONFIG_NAMESPACES
> +void audit_log_namespace_info(struct audit_buffer *ab, struct task_struct *tsk)
> +{
> +	struct nsproxy *nsproxy;
> +
> +	rcu_read_lock();

ok, so we are under rcu_read_lock() and cannot sleep

> +	nsproxy = task_nsproxy(tsk);
> +	if (nsproxy != NULL) {
> +		audit_log_format(ab, " mntns=%llx", nsproxy->mnt_ns->serial_num);

But this could do an allocation, are we sure that everything used
GFP_ATOMIC when creating the audit buffer? [hint: it doesn't]

