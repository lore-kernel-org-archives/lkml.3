Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752542AbaHKFkK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 01:40:10 -0400
Received: from thoth.sbs.de ([192.35.17.2]:52826 "EHLO thoth.sbs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752241AbaHKFkJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 01:40:09 -0400
Message-ID: <53E85731.3000507@siemens.com>
Date: Mon, 11 Aug 2014 07:40:01 +0200
From: Jan Kiszka <jan.kiszka@siemens.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Daniel Thompson <daniel.thompson@linaro.org>
CC: linux-kernel@vger.kernel.org, patches@linaro.org,
        linaro-kernel@lists.linaro.org, Michal Marek <mmarek@suse.cz>,
        linux-kbuild@vger.kernel.org
Subject: Re: [PATCH gdb/scripts] scripts/gdb: Ignore byte-compiled python
 files
References: <1407335269-9533-1-git-send-email-daniel.thompson@linaro.org>
In-Reply-To: <1407335269-9533-1-git-send-email-daniel.thompson@linaro.org>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-08-06 16:27, Daniel Thompson wrote:
> Using the gdb scripts leaves byte-compiled python files in the scripts/
> directory. These should be ignored by git and cleaned up by mrproper.
> 
> Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
> Cc: Jan Kiszka <jan.kiszka@siemens.com>
> Cc: Michal Marek <mmarek@suse.cz>
> Cc: linux-kbuild@vger.kernel.org
> ---
> 
> Notes:
>     Relies upon (and intended for incorporation into) Jan Kiszka's gdb/scripts
>     patch series.
> 
>  .gitignore                   | 1 +
>  Makefile                     | 2 +-
>  scripts/gdb/linux/.gitignore | 2 ++
>  3 files changed, 4 insertions(+), 1 deletion(-)
>  create mode 100644 scripts/gdb/linux/.gitignore
> 
> diff --git a/.gitignore b/.gitignore
> index f4c0b09..a04486e 100644
> --- a/.gitignore
> +++ b/.gitignore
> @@ -42,6 +42,7 @@ Module.symvers
>  /TAGS
>  /linux
>  /vmlinux
> +/vmlinux-gdb.py
>  /vmlinuz
>  /System.map
>  /Module.markers
> diff --git a/Makefile b/Makefile
> index 7105eb2a..a3ca8ba 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -1136,7 +1136,7 @@ MRPROPER_FILES += .config .config.old .version .old_version $(version_h) \
>  		  signing_key.priv signing_key.x509 x509.genkey		\
>  		  extra_certificates signing_key.x509.keyid		\
>  		  signing_key.x509.signer include/linux/version.h	\
> -		  vmlinux-gdb.py
> +		  vmlinux-gdb.py scripts/gdb/linux/*.py[co]
>  
>  # clean - Delete most, but leave enough to build external modules
>  #
> diff --git a/scripts/gdb/linux/.gitignore b/scripts/gdb/linux/.gitignore
> new file mode 100644
> index 0000000..52e4e61
> --- /dev/null
> +++ b/scripts/gdb/linux/.gitignore
> @@ -0,0 +1,2 @@
> +*.pyc
> +*.pyo
> 

Thanks, picked up into my queue. Rebased version pushed. I'll repost the
series once again soon.

Jan

-- 
Siemens AG, Corporate Technology, CT RTC ITP SES-DE
Corporate Competence Center Embedded Linux
