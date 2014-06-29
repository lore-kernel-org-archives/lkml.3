Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752203AbaF2CXi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 22:23:38 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:58756 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751614AbaF2CXg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 22:23:36 -0400
Message-ID: <53AF78A7.8050106@infradead.org>
Date: Sat, 28 Jun 2014 19:23:35 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Peter Foley <pefoley2@pefoley.com>, linux-kernel@vger.kernel.org
CC: linux-doc@vger.kernel.org, Michal Marek <mmarek@suse.cz>,
        linux-kbuild@vger.kernel.org
Subject: Re: [PATCH 1/4] Documentation: use subdir-y to avoid unnecessary
 built-in.o files
References: <1397743910-18391-1-git-send-email-pefoley2@pefoley.com>
In-Reply-To: <1397743910-18391-1-git-send-email-pefoley2@pefoley.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/17/14 07:11, Peter Foley wrote:
> Change the Documentation makefiles from obj-m to subdir-y
> to avoid generating unnecessary built-in.o files since nothing
> in Documentation/ is ever linked in to vmlinux.
> 
> Signed-off-by: Peter Foley <pefoley2@pefoley.com>

Hi Michal,

Does this look good to you?
I don't have enough makefile fu (or is it foo?) to judge this.

Thanks.

> ---
>  Documentation/Makefile                         | 6 +++---
>  Documentation/accounting/Makefile              | 3 ---
>  Documentation/auxdisplay/Makefile              | 3 ---
>  Documentation/filesystems/Makefile             | 3 ---
>  Documentation/ia64/Makefile                    | 3 ---
>  Documentation/laptops/Makefile                 | 3 ---
>  Documentation/misc-devices/Makefile            | 1 +
>  Documentation/misc-devices/mei/Makefile        | 3 ---
>  Documentation/networking/Makefile              | 8 +-------
>  Documentation/networking/timestamping/Makefile | 3 ---
>  Documentation/pcmcia/Makefile                  | 3 ---
>  Documentation/spi/Makefile                     | 3 ---
>  Documentation/timers/Makefile                  | 3 ---
>  Documentation/watchdog/Makefile                | 1 +
>  Documentation/watchdog/src/Makefile            | 3 ---
>  15 files changed, 6 insertions(+), 43 deletions(-)
>  create mode 100644 Documentation/misc-devices/Makefile
>  create mode 100644 Documentation/watchdog/Makefile
> 
> diff --git a/Documentation/Makefile b/Documentation/Makefile
> index 31d302b..605f84f 100644
> --- a/Documentation/Makefile
> +++ b/Documentation/Makefile
> @@ -1,3 +1,3 @@
> -obj-m := DocBook/ accounting/ auxdisplay/ connector/ \
> -	filesystems/ filesystems/configfs/ ia64/ laptops/ networking/ \
> -	pcmcia/ spi/ timers/ watchdog/src/ misc-devices/mei/
> +subdir-y := DocBook accounting auxdisplay connector \
> +	filesystems filesystems ia64 laptops networking \
> +	pcmcia spi timers watchdog misc-devices
> diff --git a/Documentation/accounting/Makefile b/Documentation/accounting/Makefile
> index 31929eb..7e232cb 100644
> --- a/Documentation/accounting/Makefile
> +++ b/Documentation/accounting/Makefile
> @@ -1,6 +1,3 @@
> -# kbuild trick to avoid linker error. Can be omitted if a module is built.
> -obj- := dummy.o
> -
>  # List of programs to build
>  hostprogs-y := getdelays
>  
> diff --git a/Documentation/auxdisplay/Makefile b/Documentation/auxdisplay/Makefile
> index 51fe233..ada4dac 100644
> --- a/Documentation/auxdisplay/Makefile
> +++ b/Documentation/auxdisplay/Makefile
> @@ -1,6 +1,3 @@
> -# kbuild trick to avoid linker error. Can be omitted if a module is built.
> -obj- := dummy.o
> -
>  # List of programs to build
>  hostprogs-y := cfag12864b-example
>  
> diff --git a/Documentation/filesystems/Makefile b/Documentation/filesystems/Makefile
> index a5dd114..883010c 100644
> --- a/Documentation/filesystems/Makefile
> +++ b/Documentation/filesystems/Makefile
> @@ -1,6 +1,3 @@
> -# kbuild trick to avoid linker error. Can be omitted if a module is built.
> -obj- := dummy.o
> -
>  # List of programs to build
>  hostprogs-y := dnotify_test
>  
> diff --git a/Documentation/ia64/Makefile b/Documentation/ia64/Makefile
> index b75db69..d493163 100644
> --- a/Documentation/ia64/Makefile
> +++ b/Documentation/ia64/Makefile
> @@ -1,6 +1,3 @@
> -# kbuild trick to avoid linker error. Can be omitted if a module is built.
> -obj- := dummy.o
> -
>  # List of programs to build
>  hostprogs-y := aliasing-test
>  
> diff --git a/Documentation/laptops/Makefile b/Documentation/laptops/Makefile
> index 5cb144a..0abe44f 100644
> --- a/Documentation/laptops/Makefile
> +++ b/Documentation/laptops/Makefile
> @@ -1,6 +1,3 @@
> -# kbuild trick to avoid linker error. Can be omitted if a module is built.
> -obj- := dummy.o
> -
>  # List of programs to build
>  hostprogs-y := dslm
>  
> diff --git a/Documentation/misc-devices/Makefile b/Documentation/misc-devices/Makefile
> new file mode 100644
> index 0000000..e2b7aa4
> --- /dev/null
> +++ b/Documentation/misc-devices/Makefile
> @@ -0,0 +1 @@
> +subdir-y := mei
> diff --git a/Documentation/misc-devices/mei/Makefile b/Documentation/misc-devices/mei/Makefile
> index 00e8c3e..d758047 100644
> --- a/Documentation/misc-devices/mei/Makefile
> +++ b/Documentation/misc-devices/mei/Makefile
> @@ -1,6 +1,3 @@
> -# kbuild trick to avoid linker error. Can be omitted if a module is built.
> -obj- := dummy.o
> -
>  # List of programs to build
>  hostprogs-y := mei-amt-version
>  HOSTCFLAGS_mei-amt-version.o += -I$(objtree)/usr/include
> diff --git a/Documentation/networking/Makefile b/Documentation/networking/Makefile
> index 0aa1ac9..4c5d7c4 100644
> --- a/Documentation/networking/Makefile
> +++ b/Documentation/networking/Makefile
> @@ -1,7 +1 @@
> -# kbuild trick to avoid linker error. Can be omitted if a module is built.
> -obj- := dummy.o
> -
> -# Tell kbuild to always build the programs
> -always := $(hostprogs-y)
> -
> -obj-m := timestamping/
> +subdir-y := timestamping
> diff --git a/Documentation/networking/timestamping/Makefile b/Documentation/networking/timestamping/Makefile
> index d934afc..bbe6f81 100644
> --- a/Documentation/networking/timestamping/Makefile
> +++ b/Documentation/networking/timestamping/Makefile
> @@ -1,6 +1,3 @@
> -# kbuild trick to avoid linker error. Can be omitted if a module is built.
> -obj- := dummy.o
> -
>  # List of programs to build
>  hostprogs-y := timestamping hwtstamp_config
>  
> diff --git a/Documentation/pcmcia/Makefile b/Documentation/pcmcia/Makefile
> index accde87..47a8fa1 100644
> --- a/Documentation/pcmcia/Makefile
> +++ b/Documentation/pcmcia/Makefile
> @@ -1,6 +1,3 @@
> -# kbuild trick to avoid linker error. Can be omitted if a module is built.
> -obj- := dummy.o
> -
>  # List of programs to build
>  hostprogs-y := crc32hash
>  
> diff --git a/Documentation/spi/Makefile b/Documentation/spi/Makefile
> index a5b03c8..efa2558 100644
> --- a/Documentation/spi/Makefile
> +++ b/Documentation/spi/Makefile
> @@ -1,6 +1,3 @@
> -# kbuild trick to avoid linker error. Can be omitted if a module is built.
> -obj- := dummy.o
> -
>  # List of programs to build
>  hostprogs-y := spidev_test spidev_fdx
>  
> diff --git a/Documentation/timers/Makefile b/Documentation/timers/Makefile
> index 73f75f8..6c09ee6 100644
> --- a/Documentation/timers/Makefile
> +++ b/Documentation/timers/Makefile
> @@ -1,6 +1,3 @@
> -# kbuild trick to avoid linker error. Can be omitted if a module is built.
> -obj- := dummy.o
> -
>  # List of programs to build
>  hostprogs-$(CONFIG_X86) := hpet_example
>  
> diff --git a/Documentation/watchdog/Makefile b/Documentation/watchdog/Makefile
> new file mode 100644
> index 0000000..6018f45
> --- /dev/null
> +++ b/Documentation/watchdog/Makefile
> @@ -0,0 +1 @@
> +subdir-y := src
> diff --git a/Documentation/watchdog/src/Makefile b/Documentation/watchdog/src/Makefile
> index 40e5f46..4a892c3 100644
> --- a/Documentation/watchdog/src/Makefile
> +++ b/Documentation/watchdog/src/Makefile
> @@ -1,6 +1,3 @@
> -# kbuild trick to avoid linker error. Can be omitted if a module is built.
> -obj- := dummy.o
> -
>  # List of programs to build
>  hostprogs-y := watchdog-simple watchdog-test
>  
> 


-- 
~Randy
