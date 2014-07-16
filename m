Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932797AbaGPCX6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 22:23:58 -0400
Received: from mail-lb0-f173.google.com ([209.85.217.173]:39363 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754748AbaGPCX4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 22:23:56 -0400
MIME-Version: 1.0
In-Reply-To: <1405193128-6848-1-git-send-email-bobby.prani@gmail.com>
References: <1405193128-6848-1-git-send-email-bobby.prani@gmail.com>
From: Pranith Kumar <bobby.prani@gmail.com>
Date: Tue, 15 Jul 2014 22:23:24 -0400
Message-ID: <CAJhHMCC1bY5ras7-W17Qh7yZq5-_eD0C-CJfa09ZpjWNoTOZ=w@mail.gmail.com>
Subject: Re: [PATCH 1/1] scripts/get_maintainer: increase threshold for
 --follow to reduce time
To: Joe Perches <joe@perches.com>, open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ping?

On Sat, Jul 12, 2014 at 3:25 PM, Pranith Kumar <bobby.prani@gmail.com> wrote:
> get_maintainer tries to follow files with a matching threshold of default 50%.
> This is not really necessary as we do not change a file and move it in the same
> commit usually. Increasing the threshold to 90% should be sufficient.
>
> I encountered this on a recent commit where I was touching 12 files. Time take
> dropped from 24 sec to 12 sec after this change. It can be reduced further by
> increasing the threshold, but I think 90% is sufficient.
>
> Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
> ---
>  scripts/get_maintainer.pl | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/scripts/get_maintainer.pl b/scripts/get_maintainer.pl
> index d701627..bc4a69e 100755
> --- a/scripts/get_maintainer.pl
> +++ b/scripts/get_maintainer.pl
> @@ -98,7 +98,7 @@ my %VCS_cmds_git = (
>      "execute_cmd" => \&git_execute_cmd,
>      "available" => '(which("git") ne "") && (-e ".git")',
>      "find_signers_cmd" =>
> -       "git log --no-color --follow --since=\$email_git_since " .
> +       "git log --no-color --follow -M90 --since=\$email_git_since " .
>             '--numstat --no-merges ' .
>             '--format="GitCommit: %H%n' .
>                       'GitAuthor: %an <%ae>%n' .
> --
> 1.9.1
>



-- 
Pranith
