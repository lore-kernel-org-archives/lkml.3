Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753574Ab3FCI6K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 04:58:10 -0400
Received: from eu1sys200aog105.obsmtp.com ([207.126.144.119]:59935 "EHLO
	eu1sys200aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752009Ab3FCI6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 04:58:08 -0400
Message-ID: <51AC5A53.1090700@st.com>
Date: Mon, 03 Jun 2013 09:56:51 +0100
From: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>
Reply-To: srinivas.kandagatla@st.com
Organization: STMicroelectronics
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Barry Song <21cnbao@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        linux-kernel@vger.kernel.org,
        DL-SHA-WorkGroupLinux <workgroup.linux@csr.com>,
        Barry Song <baohua.song@csr.com>, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v1 2/2] ARM:prima2:move postcore_initcalls to init_machine.
References: <1369993439-24216-1-git-send-email-srinivas.kandagatla@st.com> <1369993517-24735-1-git-send-email-srinivas.kandagatla@st.com> <CAGsJ_4yu2MT5o7hbX67KPhrejS9D1BbPcship4zxtXs3G9tE-Q@mail.gmail.com>
In-Reply-To: <CAGsJ_4yu2MT5o7hbX67KPhrejS9D1BbPcship4zxtXs3G9tE-Q@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/06/13 04:51, Barry Song wrote:
> did you see this one?
> 
> [PATCH v2] arm: prima2: use of_platform_populate instead of
> of_platform_bus_probe
> http://www.spinics.net/lists/arm-kernel/msg243710.html

Yes, I think this is a nice cleanup for simplest case. But Prima
platforms do much more checking at the same init level. An attempt to
get rid of postcore and early init calls might introduce this back.

You could solve both the early and postcore initcall issues by returning
instead of panic, and let every NON Prima platforms call this function.
Or
Do it the right way and clean it up.

I will leave it up to you to decide on how you want to fix the multi_v7
kernel issue.

Thanks,
srini
