Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754702Ab3EaMwW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 08:52:22 -0400
Received: from eu1sys200aog117.obsmtp.com ([207.126.144.143]:54925 "EHLO
	eu1sys200aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751564Ab3EaMwO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 08:52:14 -0400
Message-ID: <51A89ACE.8030604@st.com>
Date: Fri, 31 May 2013 13:42:54 +0100
From: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>
Reply-To: srinivas.kandagatla@st.com
Organization: STMicroelectronics
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Barry Song <21cnbao@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Barry Song <baohua.song@csr.com>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        DL-SHA-WorkGroupLinux <workgroup.linux@csr.com>
Subject: Re: [PATCH v1 1/2] ARM:prima2: move sirfsoc_of_rstc_init to .init_early
References: <1369993439-24216-1-git-send-email-srinivas.kandagatla@st.com> <1369993501-24309-1-git-send-email-srinivas.kandagatla@st.com> <CAGsJ_4z65+SOCQM2XKmrda+5Hu9wRuZviSvW3As1ROa0SmdXqw@mail.gmail.com>
In-Reply-To: <CAGsJ_4z65+SOCQM2XKmrda+5Hu9wRuZviSvW3As1ROa0SmdXqw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31/05/13 13:24, Barry Song wrote:
>> > Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@st.com>
> hi Sriniva,
> i think my "arm: prima2: move to generic reset controller driver
> framework" fixs this too:
> http://www.spinics.net/lists/arm-kernel/msg246206.html
I did look at the patch, I think it will fix it.

But the patch is still using arch_initcall directly, which means this
call will be attempted by every SOC in multi_v7 kernel.
This call can be easily hooked into machine descriptor.
In that way only prima compatible machines will attempt to call this
function in first place.

Do you know if the second issue of postcore init is fixed in any other
patches.

thanks,
srini
