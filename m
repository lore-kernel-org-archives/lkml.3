Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755629Ab3EaM5y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 08:57:54 -0400
Received: from mail-qe0-f43.google.com ([209.85.128.43]:33737 "EHLO
	mail-qe0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755349Ab3EaM5U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 08:57:20 -0400
MIME-Version: 1.0
In-Reply-To: <51A89ACE.8030604@st.com>
References: <1369993439-24216-1-git-send-email-srinivas.kandagatla@st.com>
 <1369993501-24309-1-git-send-email-srinivas.kandagatla@st.com>
 <CAGsJ_4z65+SOCQM2XKmrda+5Hu9wRuZviSvW3As1ROa0SmdXqw@mail.gmail.com> <51A89ACE.8030604@st.com>
From: Barry Song <21cnbao@gmail.com>
Date: Fri, 31 May 2013 20:56:58 +0800
Message-ID: <CAGsJ_4zaW_y0VCxZzwoK5s-Mv+M9yFXWfWuiMJ_fG9qKqDG3uQ@mail.gmail.com>
Subject: Re: [PATCH v1 1/2] ARM:prima2: move sirfsoc_of_rstc_init to .init_early
To: srinivas.kandagatla@st.com
Cc: Arnd Bergmann <arnd@arndb.de>, Barry Song <baohua.song@csr.com>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        DL-SHA-WorkGroupLinux <workgroup.linux@csr.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/5/31 Srinivas KANDAGATLA <srinivas.kandagatla@st.com>:
> On 31/05/13 13:24, Barry Song wrote:
>>> > Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@st.com>
>> hi Sriniva,
>> i think my "arm: prima2: move to generic reset controller driver
>> framework" fixs this too:
>> http://www.spinics.net/lists/arm-kernel/msg246206.html
> I did look at the patch, I think it will fix it.
>
> But the patch is still using arch_initcall directly, which means this
> call will be attempted by every SOC in multi_v7 kernel.
> This call can be easily hooked into machine descriptor.
> In that way only prima compatible machines will attempt to call this
> function in first place.

mine should fix panic as it returns 0 instead of using BUG(). but i do
think we should merge yours too to avoid redundant execution path.

>
> Do you know if the second issue of postcore init is fixed in any other
> patches.

no. i will test your v2.

>
> thanks,
> srini

-barry
