Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758329Ab3B0W4N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 17:56:13 -0500
Received: from mga01.intel.com ([192.55.52.88]:3181 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751991Ab3B0W4L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 17:56:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,751,1355126400"; 
   d="scan'208";a="296856134"
Message-ID: <512E8F09.2090003@linux.intel.com>
Date: Wed, 27 Feb 2013 14:56:09 -0800
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130215 Thunderbird/17.0.3
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: "H. Peter Anvin" <hpa@zytor.com>, Stephen Boyd <sboyd@codeaurora.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        linux-parisc@vger.kernel.org, linux-s390@vger.kernel.org,
        Helge Deller <deller@gmx.de>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Chris Metcalf <cmetcalf@tilera.com>
Subject: Re: [PATCH] Consolidate CONFIG_DEBUG_STRICT_USER_COPY_CHECK
References: <1361934016-22630-1-git-send-email-sboyd@codeaurora.org> <201302272032.21014.arnd@arndb.de> <512E6FA9.4060504@codeaurora.org> <512E8664.3070903@zytor.com> <20130228094510.3341017130e4476e046bdd22@canb.auug.org.au>
In-Reply-To: <20130228094510.3341017130e4476e046bdd22@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/27/2013 2:45 PM, Stephen Rothwell wrote:
> Hi all,
>
> On Wed, 27 Feb 2013 14:19:16 -0800 "H. Peter Anvin" <hpa@zytor.com> wrote:
>>
>> Although some of the cases I have seen being flagged as "false
>> positives" have been real bugs.
>
> [hijacking the thread :-)]
>
> I have been getting this warning for a very long time ( which would be an
> error if CONFIG_DEBUG_STRICT_USER_COPY_CHECK was set):
>
> i386 defconfig
> i386-linux-gcc (GCC) 4.6.3
>
> In file included from arch/x86/include/asm/uaccess.h:537:0,
>                   from include/linux/uaccess.h:5,
>                   from include/linux/highmem.h:8,
>                   from include/linux/pagemap.h:10,
>                   from fs/binfmt_misc.c:27:
> arch/x86/include/asm/uaccess_32.h: In function 'parse_command.part.2':
> arch/x86/include/asm/uaccess_32.h:211:26: warning: call to 'copy_from_user_overflow' declared with attribute warning: copy_from_user() buffer size is not provably correct [enabled by default]
>


http://gcc.gnu.org/bugzilla/show_bug.cgi?id=35392

the gcc folks finally fixed that one it seems

(but while there are some false positives, esp with older gcc, the majority were real originally.. just those all got fixed)


