Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754775AbaHUMOD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 08:14:03 -0400
Received: from mail-ig0-f178.google.com ([209.85.213.178]:41304 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754019AbaHUMOA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 08:14:00 -0400
Date: Thu, 21 Aug 2014 13:13:55 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Julia Lawall <julia.lawall@lip6.fr>
Cc: Samuel Ortiz <sameo@linux.intel.com>, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] mfd: menelaus: fix error return code
Message-ID: <20140821121355.GG4266@lee--X1>
References: <1407355938-10932-2-git-send-email-Julia.Lawall@lip6.fr>
 <20140821082605.GS4266@lee--X1>
 <alpine.DEB.2.10.1408210705250.2534@hadrien>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.DEB.2.10.1408210705250.2534@hadrien>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Aug 2014, Julia Lawall wrote:

> Convert a zero return value on error to a negative one, as returned
> elsewhere in the function.
> 
> Additionally, converted 1 << 7 to BIT(7) at the suggestion of Lee Jones.
> 
> A simplified version of the semantic match that finds this problem is as
> follows: (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> (
> if@p1 (\(ret < 0\|ret != 0\))
>  { ... return ret; }
> |
> ret@p1 = 0
> )
> ... when != ret = e1
>     when != &ret
> *if(...)
> {
>   ... when != ret = e2
>       when forall
>  return ret;
> }
> 
> // </smpl>
> 
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> ---
> v2: Drop the name "val" and use BIT(7).

Thanks Julia.  Patch applied.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
