Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756768Ab3CSXvU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 19:51:20 -0400
Received: from mail-da0-f43.google.com ([209.85.210.43]:52449 "EHLO
	mail-da0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755522Ab3CSXvS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 19:51:18 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Peter De Schrijver <pdeschrijver@nvidia.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <1363113747-6572-1-git-send-email-pdeschrijver@nvidia.com>
Cc: <linux-tegra@vger.kernel.org>, Stephen Warren <swarren@nvidia.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
References: <1363113747-6572-1-git-send-email-pdeschrijver@nvidia.com>
Message-ID: <20130319235110.8663.67548@quantum>
User-Agent: alot/0.3.3+
Subject: Re: [PATCH] clk: add table lookup to mux
Date: Tue, 19 Mar 2013 16:51:10 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Peter De Schrijver (2013-03-12 11:42:23)
> diff --git a/include/linux/clk-private.h b/include/linux/clk-private.h
> index 9c7f580..53d39c2 100644
> --- a/include/linux/clk-private.h
> +++ b/include/linux/clk-private.h
> @@ -144,12 +144,13 @@ struct clk {
>  
>  #define DEFINE_CLK_MUX(_name, _parent_names, _parents, _flags, \
>                                 _reg, _shift, _width,           \
> -                               _mux_flags, _lock)              \
> +                               _mux_flags, _table, _lock)      \
>         static struct clk _name;                                \
>         static struct clk_mux _name##_hw = {                    \
>                 .hw = {                                         \
>                         .clk = &_name,                          \
>                 },                                              \
> +               .table = _table,                                \
>                 .reg = _reg,                                    \
>                 .shift = _shift,                                \
>                 .width = _width,                                \

This breaks OMAP horribly since OMAP already uses this macro.  There are
two options:

1) stop using statically initialized data and no longer use
clk-private.h macros.  I was under the impression that the tegra clock
data no longer required this?

2) if you must continue to use the clk-private.h macros (temporarily!)
then create a new one, DEFINE_CLK_MUX_TABLE.

Regards,
Mike
