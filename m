Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752345AbaB0XK7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 18:10:59 -0500
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:40413 "HELO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751067AbaB0XK6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 18:10:58 -0500
MIME-Version: 1.0
In-Reply-To: <1393539059-21727-1-git-send-email-zoltan.kiss@citrix.com>
References: <1393539059-21727-1-git-send-email-zoltan.kiss@citrix.com>
Date: Thu, 27 Feb 2014 15:04:56 -0800
Message-ID: <CALnjE+pwjMCDUPP8+DsAbamNxk8nVFKqTa3yC8sZNYFqeFGjHQ@mail.gmail.com>
Subject: Re: [PATCH v2] openvswitch: Disable bottom half when grabbing stats
 lock in userspace context
From: Pravin Shelar <pshelar@nicira.com>
To: Zoltan Kiss <zoltan.kiss@citrix.com>
Cc: Jesse Gross <jesse@nicira.com>,
        "dev@openvswitch.org" <dev@openvswitch.org>,
        netdev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 27, 2014 at 2:10 PM, Zoltan Kiss <zoltan.kiss@citrix.com> wrote:
> The megaflow feature introduced per-CPU stats, and the new code did some
> refactoring as well [1]. However the new functions doesn't disable bottom halves
> when locking the stat, and as they can be called from userspace context, they
> can be interrupted by netif_receive_skb.
>
> [1] e298e50570: openvswitch: Per cpu flow stats.
>
This bug is fixed in openvswitch repo by commit "datapath: Fix
deadlock during stats update."


Thanks.
