Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755553Ab3IZGn3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 02:43:29 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:57722 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751574Ab3IZGn2 convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:3:1>);
	Thu, 26 Sep 2013 02:43:28 -0400
Message-Id: <5243F3C602000078000F693D@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.2 
Date: Thu, 26 Sep 2013 07:43:50 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>
Cc: <xen-devel@lists.xenproject.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] xen/mmu: Correct PAT MST setting.
References: <1380137367-8357-1-git-send-email-konrad.wilk@oracle.com>
In-Reply-To: <1380137367-8357-1-git-send-email-konrad.wilk@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 25.09.13 at 21:29, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
> Jan Beulich spotted that the PAT MSR settings in the Xen public
> document that "the first (PAT6) column was wrong across the
> board, and the column for PAT7 was missing altogether."
> 
> This updates it to be in sync.
> 
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

Acked-by: Jan Beulich <jbeulich@suse.com>

> ---
>  arch/x86/xen/mmu.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
> index fdc3ba2..c9631e7 100644
> --- a/arch/x86/xen/mmu.c
> +++ b/arch/x86/xen/mmu.c
> @@ -468,8 +468,8 @@ PV_CALLEE_SAVE_REGS_THUNK(xen_pgd_val);
>   * 3        PCD PWT      UC       UC     UC
>   * 4    PAT              WB       WC     WB
>   * 5    PAT     PWT      WC       WP     WT
> - * 6    PAT PCD          UC-      UC     UC-
> - * 7    PAT PCD PWT      UC       UC     UC
> + * 6    PAT PCD          UC-      rsv    UC-
> + * 7    PAT PCD PWT      UC       rsv    UC
>   */
>  
>  void xen_set_pat(u64 pat)
> -- 
> 1.8.3.1



