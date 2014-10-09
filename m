Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757605AbaJIVyq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 17:54:46 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:55143 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026AbaJIVyo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 17:54:44 -0400
Date: Thu, 9 Oct 2014 14:54:41 -0700
From: Omar Sandoval <osandov@osandov.com>
To: Cong Wang <cwang@twopensource.com>
Cc: Jamal Hadi Salim <jhs@mojatatu.com>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net sched: text ematch: zero out ts_state before using it
Message-ID: <20141009215441.GA1830@mew.dhcp4.washington.edu>
References: <1412870721-31061-1-git-send-email-osandov@osandov.com>
 <CAHA+R7Ot5u6F1zi4egLqOXPWbQrdLxdUQybaFEp5_aa463d4Bw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHA+R7Ot5u6F1zi4egLqOXPWbQrdLxdUQybaFEp5_aa463d4Bw@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 09, 2014 at 02:48:54PM -0700, Cong Wang wrote:
> On Thu, Oct 9, 2014 at 9:05 AM, Omar Sandoval <osandov@osandov.com> wrote:
> > textsearch_find zeroes out the offset, but the control buffer (which may or may
> > not matter in this case) needs to be zeroed out as well.
> 
> Why? skb_prepare_seq_read() initializes the cb.
> 
> Also, the comment says:
> 
>  * @state: uninitialized textsearch state variable

Mm, thanks, I missed that. It looks like every other caller of skb_find_text is
doing an unnecessary memset in that case. Disregard this, I guess.
-- 
Omar
