Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760082Ab3B0Nzt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 08:55:49 -0500
Received: from cantor2.suse.de ([195.135.220.15]:37808 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759904Ab3B0Nzr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 08:55:47 -0500
Message-ID: <512E1061.3030007@suse.cz>
Date: Wed, 27 Feb 2013 14:55:45 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Sedat Dilek <sedat.dilek@googlemail.com>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sedat Dilek <sedat.dilek@gmail.com>, maximilian attems <max@stro.at>
Subject: Re: [PATCH 1/3] kbuild, deb-pkg: Try to determine distribution
References: <1335219389-10887-1-git-send-email-sedat.dilek@gmail.com>
In-Reply-To: <1335219389-10887-1-git-send-email-sedat.dilek@gmail.com>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry I missed this series. Max, can you have a look? I don't know the
policies for debian package changelogs. The full series is at
http://lkml.indiana.edu/hypermail/linux/kernel/1204.2/index.html#04252,
but the remaining two patches are obvious.

Michal

On 24.4.2012 00:16, Sedat Dilek wrote:
> Signed-off-by: Sedat Dilek <sedat.dilek@gmail.com>
> ---
>  scripts/package/builddeb |   15 ++++++++++++++-
>  1 file changed, 14 insertions(+), 1 deletion(-)
> 
> diff --git a/scripts/package/builddeb b/scripts/package/builddeb
> index eee5f8e..f5b56ac 100644
> --- a/scripts/package/builddeb
> +++ b/scripts/package/builddeb
> @@ -172,9 +172,22 @@ else
>  fi
>  maintainer="$name <$email>"
>  
> +# Try to determine distribution
> +if [ -e $(which lsb_release) ]; then
> +       codename=$(lsb_release --codename --short)
> +       if [ "$codename" != "" ]; then
> +		distribution=$codename
> +       else
> +		distribution="UNRELEASED"
> +		echo "WARNING: The distribution could NOT be determined!"
> +       fi
> +else
> +       echo "HINT: Install lsb_release binary, this helps to identify your distribution!"
> +fi
> +
>  # Generate a simple changelog template
>  cat <<EOF > debian/changelog
> -linux-upstream ($packageversion) unstable; urgency=low
> +linux-upstream ($packageversion) $distribution; urgency=low
>  
>    * Custom built Linux kernel.
>  
> 


