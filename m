Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755902AbaBUPNc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 10:13:32 -0500
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:51361 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755227AbaBUPNb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 10:13:31 -0500
Message-ID: <53076D16.9030204@hurleysoftware.com>
Date: Fri, 21 Feb 2014 10:13:26 -0500
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>, laijs@cn.fujitsu.com
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 8/9] staging/fwserial: don't use PREPARE_WORK
References: <1392929071-16555-1-git-send-email-tj@kernel.org> <1392929071-16555-9-git-send-email-tj@kernel.org>
In-Reply-To: <1392929071-16555-9-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/20/2014 03:44 PM, Tejun Heo wrote:
> PREPARE_[DELAYED_]WORK() are being phased out.  They have few users
> and a nasty surprise in terms of reentrancy guarantee as workqueue
> considers work items to be different if they don't have the same work
> function.
>
> fwtty_peer->work is multiplexed with multiple work functions.
> Introduce fwserial_peer_workfn() which invokes fwtty_peer->workfn and
> always use it as the work function and update the users to set the
> ->workfn field instead of overriding the work function using
> PREPARE_WORK().
>
> It would probably be best to route this with other related updates
> through the workqueue tree.
>
> Compile tested.
>
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Peter Hurley <peter@hurleysoftware.com>

Acked-by: Peter Hurley <peter@hurleysoftware.com>


