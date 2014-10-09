Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933010AbaJIVtD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 17:49:03 -0400
Received: from mail-qg0-f41.google.com ([209.85.192.41]:55277 "EHLO
	mail-qg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932457AbaJIVsz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 17:48:55 -0400
MIME-Version: 1.0
In-Reply-To: <1412870721-31061-1-git-send-email-osandov@osandov.com>
References: <1412870721-31061-1-git-send-email-osandov@osandov.com>
Date: Thu, 9 Oct 2014 14:48:54 -0700
Message-ID: <CAHA+R7Ot5u6F1zi4egLqOXPWbQrdLxdUQybaFEp5_aa463d4Bw@mail.gmail.com>
Subject: Re: [PATCH] net sched: text ematch: zero out ts_state before using it
From: Cong Wang <cwang@twopensource.com>
To: Omar Sandoval <osandov@osandov.com>
Cc: Jamal Hadi Salim <jhs@mojatatu.com>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 9, 2014 at 9:05 AM, Omar Sandoval <osandov@osandov.com> wrote:
> textsearch_find zeroes out the offset, but the control buffer (which may or may
> not matter in this case) needs to be zeroed out as well.

Why? skb_prepare_seq_read() initializes the cb.

Also, the comment says:

 * @state: uninitialized textsearch state variable
