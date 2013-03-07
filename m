Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932699Ab3CGLhB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 06:37:01 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:56696 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932455Ab3CGLg7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 06:36:59 -0500
Date: Thu, 7 Mar 2013 11:36:53 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/8] ARM/etm/sysrq: fix inconstistent help message of
	sysrq key
Message-ID: <20130307113653.GE17833@n2100.arm.linux.org.uk>
References: <51385727.3080206@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51385727.3080206@huawei.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 07, 2013 at 05:00:23PM +0800, zhangwei(Jovi) wrote:
> Currently help message of /proc/sysrq-trigger highlight its
> upper-case characters, like below:
> 
>       SysRq : HELP : loglevel(0-9) reBoot Crash terminate-all-tasks(E)
>       memory-full-oom-kill(F) kill-all-tasks(I) ...
> 
> this would confuse user trigger sysrq by upper-case character, which is
> inconsistent with the real lower-case character registed key.
> 
> This inconsistent help message will also lead more confused when
> 26 upper-case letters put into use in future.
> 
> This patch fix arm etm sysrq key: "etm buffer dump(v)"

Umm, actually this is wrong.  sysrq doesn't deal with case.

static int sysrq_key_table_key2index(int key)
{
        int retval;

        if ((key >= '0') && (key <= '9'))
                retval = key - '0';
        else if ((key >= 'a') && (key <= 'z'))
                retval = key + 10 - 'a';
        else
                retval = -1;
        return retval;
}

It actually accepts no upper case characters (because they can't be
typed on a PC keyboard with the simple code that is sysrq.)  The sysrq
key combinations there are Alt+Sysrq+key.

All sysrq help messages give the key in parens with a capital letter.
However, there's one change you should make to this anyway - there
should be no spaces in the help message - instead, the spaces should
be the "-" character.  Space is used to separate each sysrq key help
message.

Thanks.
