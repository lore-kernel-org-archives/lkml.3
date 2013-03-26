Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754057Ab3CZR5D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 13:57:03 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:48789 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751964Ab3CZR47 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 13:56:59 -0400
MIME-Version: 1.0
In-Reply-To: <1364319962-30967-3-git-send-email-cody@linux.vnet.ibm.com>
References: <1364319962-30967-1-git-send-email-cody@linux.vnet.ibm.com>
	<1364319962-30967-3-git-send-email-cody@linux.vnet.ibm.com>
Date: Tue, 26 Mar 2013 10:56:58 -0700
X-Google-Sender-Auth: J1kJXSvGEu3jNfcwPnZtsPLw3bM
Message-ID: <CAE9FiQVSPdCqaLKapG4DJ1CXtPKb8F29=s_-e9OLpXP7yG1XTA@mail.gmail.com>
Subject: Re: [PATCH 2/3] x86/mm/numa: use setup_nr_node_ids() instead of opencoding.
From: Yinghai Lu <yinghai@kernel.org>
To: Cody P Schafer <cody@linux.vnet.ibm.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org,
        Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Paul Mackerras <paulus@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 26, 2013 at 10:46 AM, Cody P Schafer
<cody@linux.vnet.ibm.com> wrote:
> Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
> ---
>  arch/x86/mm/numa.c | 9 +++------
>  1 file changed, 3 insertions(+), 6 deletions(-)
>
> diff --git a/arch/x86/mm/numa.c b/arch/x86/mm/numa.c
> index 72fe01e..a71c4e2 100644
> --- a/arch/x86/mm/numa.c
> +++ b/arch/x86/mm/numa.c
> @@ -114,14 +114,11 @@ void numa_clear_node(int cpu)
>   */
>  void __init setup_node_to_cpumask_map(void)
>  {
> -       unsigned int node, num = 0;
> +       unsigned int node;
>
>         /* setup nr_node_ids if not done yet */
> -       if (nr_node_ids == MAX_NUMNODES) {
> -               for_each_node_mask(node, node_possible_map)
> -                       num = node;
> -               nr_node_ids = num + 1;
> -       }
> +       if (nr_node_ids == MAX_NUMNODES)
> +               setup_nr_node_ids();

For 1 and 2,

Acked-by: Yinghai Lu <yinghai@kernel.org>
