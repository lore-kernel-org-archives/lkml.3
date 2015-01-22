Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752677AbbAVBNp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 20:13:45 -0500
Received: from mail-oi0-f44.google.com ([209.85.218.44]:62247 "EHLO
	mail-oi0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751730AbbAVBNf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 20:13:35 -0500
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:157d:640c:f053:c77b:4aef]
In-Reply-To: <1407202310-3359-9-git-send-email-sboyd@codeaurora.org>
References: <1407202310-3359-1-git-send-email-sboyd@codeaurora.org>
	<1407202310-3359-9-git-send-email-sboyd@codeaurora.org>
Date: Wed, 21 Jan 2015 17:13:35 -0800
Message-ID: <CAOesGMh1HE+hMP0VWr2vaHCp2itVjpQeiiFL6r9WeJUFes5tvw@mail.gmail.com>
Subject: Re: [PATCH 8/8] msm: scm: Move the scm driver to drivers/soc/qcom
From: Olof Johansson <olof@lixom.net>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: David Brown <davidb@codeaurora.org>, Kumar Gala <galak@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Lina Iyer <lina.iyer@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I just saw this in the pull request from Kumar, so this is a bit late
w.r.t. to the patch, but so was his merging of the code. :)



On Mon, Aug 4, 2014 at 6:31 PM, Stephen Boyd <sboyd@codeaurora.org> wrote:
> Architectural changes in the ARM Linux kernel tree mandate
> the eventual removal of the mach-* directories. Move the
> scm driver to drivers/soc/qcom and the scm header to
> include/soc/qcom to support that removal.

The idea is not blindly move one dumping ground to a new place.

I see only two exported functions from scm.c:

scm_get_version: This is not used anywhere in the kernel and can just be removed
scm_call: This is used by scm-boot, and would be better to translate
over to firmware_ops in the first place.


So, can you please rework this with the above in mind instead of just
moving the files over? Thanks!


-Olof
