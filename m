Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753103Ab3EaDcR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 23:32:17 -0400
Received: from mail-vc0-f169.google.com ([209.85.220.169]:49527 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751494Ab3EaDcK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 23:32:10 -0400
MIME-Version: 1.0
In-Reply-To: <20130530114132.12653.19059.stgit@ladj378.jer.intel.com>
References: <20130530114045.12653.79183.stgit@ladj378.jer.intel.com>
	<20130530114132.12653.19059.stgit@ladj378.jer.intel.com>
Date: Fri, 31 May 2013 11:32:09 +0800
Message-ID: <CAM_iQpWXuSwnRKeQYdi0bNVMMOvT=VEzF6jbHNHPa+VoUaUapA@mail.gmail.com>
Subject: Re: [PATCH v7 net-next 4/5] ixgbe: Add support for ndo_ll_poll
From: Cong Wang <xiyou.wangcong@gmail.com>
To: Eliezer Tamir <eliezer.tamir@linux.intel.com>
Cc: David Miller <davem@davemloft.net>, LKML <linux-kernel@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Don Skidmore <donald.c.skidmore@intel.com>,
        e1000-devel@lists.sourceforge.net,
        Willem de Bruijn <willemb@google.com>,
        Eric Dumazet <erdnetdev@gmail.com>,
        Ben Hutchings <bhutchings@solarflare.com>,
        Andi Kleen <andi@firstfloor.org>, HPA <hpa@zytor.com>,
        Eilon Greenstien <eilong@broadcom.com>,
        Or Gerlitz <or.gerlitz@gmail.com>, Alex Rosenbaum <alexr@mellanox.com>,
        Eliezer Tamir <eliezer@tamir.org.il>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 30, 2013 at 7:41 PM, Eliezer Tamir
<eliezer.tamir@linux.intel.com> wrote:
....
> +#else /* CONFIG_NET_LL_RX_POLL */
> +static inline void ixgbe_qv_init_lock(struct ixgbe_q_vector *q_vector)
> +{
> +}
> +
> +static inline int ixgbe_qv_lock_napi(struct ixgbe_q_vector *q_vector)
> +{
> +       return true;
> +}
> +
> +static inline int ixgbe_qv_unlock_napi(struct ixgbe_q_vector *q_vector)
> +{
> +       return false;
> +}
> +
> +static inline int ixgbe_qv_lock_poll(struct ixgbe_q_vector *q_vector)
> +{
> +       return false;
> +}
> +
> +static inline int ixgbe_qv_unlock_poll(struct ixgbe_q_vector *q_vector)
> +{
> +       return false;
> +}
> +
> +static inline int ixgbe_qv_ll_polling(struct ixgbe_q_vector *q_vector)
> +{
> +       return false;
> +}


Then please make them bool.
