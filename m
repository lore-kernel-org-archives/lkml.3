Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161895Ab3DEOrM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 10:47:12 -0400
Received: from mail-la0-f43.google.com ([209.85.215.43]:49196 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161852Ab3DEOrL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 10:47:11 -0400
MIME-Version: 1.0
X-Originating-IP: [93.172.123.88]
In-Reply-To: <1365168036.14760.4.camel@fli24-HP-Compaq-8100-Elite-CMT-PC>
References: <1362037031.6212.3.camel@fli24-HP-Compaq-8100-Elite-CMT-PC>
 <1362037455.6212.8.camel@fli24-HP-Compaq-8100-Elite-CMT-PC>
 <1362037892.6212.13.camel@fli24-HP-Compaq-8100-Elite-CMT-PC>
 <1362038236.6212.18.camel@fli24-HP-Compaq-8100-Elite-CMT-PC>
 <1362038529.6212.22.camel@fli24-HP-Compaq-8100-Elite-CMT-PC> <1365168036.14760.4.camel@fli24-HP-Compaq-8100-Elite-CMT-PC>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Fri, 5 Apr 2013 17:46:49 +0300
Message-ID: <CAK=Wgbb7ZDhG5yeBVWZJ2TYpo-ckTYsrtQ6MR=Ge0tKz5bts6A@mail.gmail.com>
Subject: Re: [PATCH 5/5 V2] hwspinlock/core: call pm_runtime_put in
 pm_runtime_get_sync failed case
To: Li Fei <fei.li@intel.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chuansheng Liu <chuansheng.liu@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 5, 2013 at 4:20 PM, Li Fei <fei.li@intel.com> wrote:
> Even in failed case of pm_runtime_get_sync, the usage_count
> is incremented. In order to keep the usage_count with correct
> value and runtime power management to behave correctly, call
> pm_runtime_put(_sync) in such case.
>
> In __hwspin_lock_request, module_put is also called before
> return in pm_runtime_get_sync failed case.
>
> Signed-off-by Liu Chuansheng <chuansheng.liu@intel.com>
> Signed-off-by: Li Fei <fei.li@intel.com>

Applied (after fixing the commit log to reflect the recent change), thanks!
