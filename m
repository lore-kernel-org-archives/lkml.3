Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754486AbaIBRGR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 13:06:17 -0400
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:13397 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753524AbaIBRGQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 13:06:16 -0400
Date: Tue, 2 Sep 2014 10:06:16 -0700
From: Bjorn Andersson <bjorn.andersson@sonymobile.com>
To: Linus Walleij <linus.walleij@linaro.org>
CC: Pramod Gurav <pramod.gurav@smartplayin.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Andy Gross <agross@codeaurora.org>
Subject: Re: [PATCH v3 4/4] pinctrl: qcom: Add support for reset for apq8064
Message-ID: <20140902170615.GO12494@sonymobile.com>
References: <1409322659-17693-1-git-send-email-pramod.gurav@smartplayin.com>
 <1409322659-17693-5-git-send-email-pramod.gurav@smartplayin.com>
 <CACRpkdbnkgb2YOKAPTFSaDhj7OMbfF+14_PeDch5mFLwjOANEw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CACRpkdbnkgb2YOKAPTFSaDhj7OMbfF+14_PeDch5mFLwjOANEw@mail.gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 02 Sep 05:36 PDT 2014, Linus Walleij wrote:

> A bit dirty to have this in this driver, but who cares.
> 

Indeed, but we figured the taint was small enough to justify not creating
cross-references to a separate driver.

> Does the APQ8064 accompanying PMIC also have the ability to
> completely shut the system down?
> 

Upon flipping pshold the PMIC will perform either a reset or a shutdown of the
system. Per Stephen's suggestion we can hook the control of this up with a
reboot_notifier in a pmic driver, hence saving ourselves of a reference to (or
from) the PMIC here.

Regards,
Bjorn
