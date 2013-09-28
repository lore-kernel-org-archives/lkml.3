Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755587Ab3I1Xm2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Sep 2013 19:42:28 -0400
Received: from mail-qe0-f50.google.com ([209.85.128.50]:39534 "EHLO
	mail-qe0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755467Ab3I1XmZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Sep 2013 19:42:25 -0400
MIME-Version: 1.0
In-Reply-To: <1380411144-9236-10-git-send-email-geyslan@gmail.com>
References: <1380411144-9236-1-git-send-email-geyslan@gmail.com>
	<1380411144-9236-10-git-send-email-geyslan@gmail.com>
Date: Sat, 28 Sep 2013 20:42:24 -0300
Message-ID: <CAGG-pUT+VvYad5ykOkDTwt9-DRspo56FaD5HzOZuyaZA7+KkDw@mail.gmail.com>
Subject: Re: [PATCH 1/1] fs/binfmt_elf.c: fill_note_info: Reduce scope of a variable
From: =?UTF-8?Q?Geyslan_Greg=C3=B3rio_Bem?= <geyslan@gmail.com>
To: ericvh@gmail.com, rminnich@sandia.gov, lucho@ionkov.net
Cc: v9fs-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        "Geyslan G. Bem" <geyslan@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please, disconsider this e-mail.

Geyslan Gregório Bem
hackingbits.com


2013/9/28 Geyslan G. Bem <geyslan@gmail.com>:
> The *t variable in the fill_note_info function is only used if
> siginfo->si_signo isn't 0. Moving "t" pointer to that inner scope.
>
> Tested.
>
> Signed-off-by: Geyslan G. Bem <geyslan@gmail.com>
> ---
>  fs/binfmt_elf.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
> index 100edcc..d0ac15b 100644
> --- a/fs/binfmt_elf.c
> +++ b/fs/binfmt_elf.c
> @@ -1848,12 +1848,11 @@ static int fill_note_info(struct elfhdr *elf, int phdrs,
>                           struct elf_note_info *info,
>                           siginfo_t *siginfo, struct pt_regs *regs)
>  {
> -       struct list_head *t;
> -
>         if (!elf_note_info_init(info))
>                 return 0;
>
>         if (siginfo->si_signo) {
> +               struct list_head *t;
>                 struct core_thread *ct;
>                 struct elf_thread_status *ets;
>
> --
> 1.8.4
>
