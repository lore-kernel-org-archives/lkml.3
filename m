Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753621AbaEJR3X (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2014 13:29:23 -0400
Received: from merlin.infradead.org ([205.233.59.134]:55093 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751001AbaEJR3W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2014 13:29:22 -0400
Message-ID: <536E61EE.3000705@infradead.org>
Date: Sat, 10 May 2014 10:29:18 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: George Spelvin <linux@horizon.com>, tj@kernel.org
CC: akpm@linux-foundation.org, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org, mingo@redhat.com,
        torvalds@linux-foundation.org
Subject: Re: [PATCH 1/2] Add lib/glob.c
References: <20140510031356.22726.qmail@ns.horizon.com>
In-Reply-To: <20140510031356.22726.qmail@ns.horizon.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/09/2014 08:13 PM, George Spelvin wrote:
> This is a helper function from drivers/ata/libata_core.c, where it is used
> to blacklist particular device models.  It's being moved to lib/ so other
> drivers may use it for the same purpose.
> 
> This implementation in non-recursive, so is safe for the kernel stack.
> 
> Signed-off-by: George Spelvin <linux@horizon.com>
> ---
> Finally rescued this from the back burner.  The code size will go back
> down in the second patch which removes the old implementation, although
> the number of source line reflects more comments and a test driver.
> 
> The infrastructure parts of this, such as the module name and Kconfig
> declarations, are something I haven't done before, and comments are
> appreciated.
> 
> Tejun Heo <htejun@gmail.com> wrote:
>> On Wed, Mar 12, 2014 at 06:52:44PM -0400, George Spelvin wrote:
>>> Sure; I'll prepare some patches.  May I feed it through you, or
>>> is there a lib/ maintainer I need to go through?
>>
>> Please keep me cc'd but you'd probably also want to cc Linus, Andrew
>> Morton and Ingo.
> 
>  include/linux/glob.h |  10 +++
>  lib/Kconfig          |  14 ++++
>  lib/Makefile         |   2 +
>  lib/glob.c           | 225 +++++++++++++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 251 insertions(+)
>  create mode 100644 include/linux/glob.h
>  create mode 100644 lib/glob.c

> diff --git a/lib/Kconfig b/lib/Kconfig
> index 991c98b..5333d10 100644
> --- a/lib/Kconfig
> +++ b/lib/Kconfig
> @@ -373,6 +373,20 @@ config CPU_RMAP
>  config DQL
>  	bool
>  
> +config GLOB
> +	tristate
> +#	(Prompt disabled to reduce kbuild clutter until someone needs it.)
> +#	prompt "glob_match() function"
> +	help
> +	  This option provides a glob_match function for performing simple
> +	  text pattern matching.  It is primarily used by the ATA code
> +	  to blacklist particular drive models, but other device drivers
> +	  may need similar functionality.
> +
> +	  All in-kernel drivers that require this function automatically

	I would drop "automatically". It has to be coded.

> +	  select this option.  Say N unless you are compiling an out-of
> +	  tree driver which tells you it depend on it.

	To support out-of-tree drivers, I'm pretty sure that you will need
	to use obj- instead of lib-.  lib- drops unused code, like Tejun said.

> +
>  #
>  # Netlink attribute parsing support is select'ed if needed
>  #


-- 
~Randy
