Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753059Ab3ITQy3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 12:54:29 -0400
Received: from mail-ob0-f173.google.com ([209.85.214.173]:46694 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752285Ab3ITQy1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 12:54:27 -0400
MIME-Version: 1.0
In-Reply-To: <523C66C5.9040008@linux.vnet.ibm.com>
References: <CACRpkdYo24DO7ra7cgc54BUN-1SGfmbdhacOT41n2=KknyEtLw@mail.gmail.com>
	<45987104.t6r4hvPgQn@vostro.rjw.lan>
	<523AF22F.1010909@linux.vnet.ibm.com>
	<CACRpkdYxiDA25Yb+csWWgXMmJuKMMTNVbdF+2JUnsSrXQpYysQ@mail.gmail.com>
	<CACRpkdYBYdMJ6mTGUropOypx0ZVNn8eQMzV+eKocCSBZAu6xTA@mail.gmail.com>
	<CAKohpokQO82XMGwcTjVmNTbBVESyFqV4DAxMMU_RHEtN+LqUgg@mail.gmail.com>
	<CACRpkdYoNkgno24dtJAwOq2T9yoKQYgKQ+adfkSN8affYNePjQ@mail.gmail.com>
	<CAKohpokdOXrGVxEA89yrAq2T8MiqZNHrrXNagqqggo67rEmKYg@mail.gmail.com>
	<CAKohpomXsZ+BsE7j-J4qU+x9f+JPsNEMi3d=CmfMByzPw_wvtw@mail.gmail.com>
	<523C66C5.9040008@linux.vnet.ibm.com>
Date: Fri, 20 Sep 2013 22:24:26 +0530
Message-ID: <CAKohpo=b8WiE5kY8u4d5RDtJazR-U+NMR1jJTS85wTc9hvkGYA@mail.gmail.com>
Subject: Re: Regression on cpufreq in v3.12-rc1
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20 September 2013 20:46, Srivatsa S. Bhat
<srivatsa.bhat@linux.vnet.ibm.com> wrote:
> I think show() and store() also suffer
> from a similar fate. So do you think we need to add these checks there as well?
> I'm not sure, since I can't think of a situation in which show() or store()
> can be invoked before the cpufreq-driver is registered.. or, is such a
> situation possible with cpufreq_disabled()?

cpufreq_disabled() is supposed to be called at boot time, so that
cpufreq_core_init() fails.. and so show/store wouldn't exist without
a driver..
