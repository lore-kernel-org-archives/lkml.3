Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755593Ab3H2RUk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 13:20:40 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:61263 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755435Ab3H2RUj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 13:20:39 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Michal Simek <michal.simek@xilinx.com>
Subject: Re: [PATCH RFC v2 16/16] ARM: zynq: Don't call of_clk_init()
Date: Thu, 29 Aug 2013 19:20:13 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Soren Brinkmann <soren.brinkmann@xilinx.com>,
        Mike Turquette <mturquette@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <1376964271-22715-1-git-send-email-sebastian.hesselbarth@gmail.com> <201308291537.54608.arnd@arndb.de> <89b68978-7eeb-43e1-a456-d864ed313da5@DB8EHSMHS026.ehs.local>
In-Reply-To: <89b68978-7eeb-43e1-a456-d864ed313da5@DB8EHSMHS026.ehs.local>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201308291920.13983.arnd@arndb.de>
X-Provags-ID: V02:K0:RBq1/wY5zWvkpH5uDRy/sCX1ZVQAzI/zn0qcwNH8o2s
 e1fovo2BcyiyzsCcWSOPZ6iq5Or49qeFPwndTd+oa2axvXO8cU
 +7DX954oXAsyamSE5jKPEwUkg1fd+0u5HuY6NehyDpyrhdXpI2
 4kJxokpSwMigZw1cjWmSlFEpWvHj2bIrudAJ3U+JGYElBAFlZ/
 ZV8DJ4roa4LfRxOsI9u6HVdC4iIqr0QGq779S2JvUXkiFVnY2n
 LmobXkXEbGw9ELPYlDobp6KCmKWG/S2IWOHf0zYLNpTLPHfUzj
 koB0oUNzQsOcV/8wEGSPpOT/I9ICHgHQwx7CL/FNrVHlkAHysD
 1/aqXTQi6pW6Xaalky+c=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 29 August 2013, Michal Simek wrote:
> Is there any plan to remove all of them?
> I expect that on almost all platforms it is a need to have at least one
> early hook to be able to setup things.

In an ideal world, we wouldn't need any, and on arm64 we don't plan to
introduce callbacks in the first place. We don't put a lot of effort
into eliminating all the ones from existing platforms in the near future,
but but I do hope to have a situation where we don't use any callbacks
for newly introduced 32-bit platforms soon, and remove a lot of the
existing callbacks over time when we have the chance (like now for the
clk init).

	Arnd
