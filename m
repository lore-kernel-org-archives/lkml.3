Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755040Ab3H2Nq0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 09:46:26 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:56316 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753288Ab3H2NqY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 09:46:24 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Subject: Re: [PATCH RFC v2 01/16] ARM: call clk_of_init from time_init
Date: Thu, 29 Aug 2013 15:45:37 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: =?utf-8?q?S=C3=B6ren_Brinkmann?= <soren.brinkmann@xilinx.com>,
        Russell King <linux@arm.linux.org.uk>, linux-tegra@vger.kernel.org,
        kernel@stlinux.com, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <1376964271-22715-1-git-send-email-sebastian.hesselbarth@gmail.com> <3837b119-baad-4e68-8805-2bc52c0135f9@DB9EHSMHS031.ehs.local> <521D2F1F.1070103@gmail.com>
In-Reply-To: <521D2F1F.1070103@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201308291545.37520.arnd@arndb.de>
X-Provags-ID: V02:K0:ghALSztcDJHwtMlUyPp2bE9osZ60qnc9je6leC3fEbH
 PAeU85eTU6sTypyvHWKxbIAaBWgi8IL3qqoyFFC/d1j4Wi+/qz
 knSoaRak2xd1/9Uskc0aCfJvAhaAATlBwfeYwIzAMjPtTPnAvn
 GJGE429YDDfINyz93UHmCN3Z7M87F8/vVoKwNDs8682OJzhiUR
 uHGEZfGYginnNzsVMQKaevDAYKmtnjLkBTemmqxEEu9rrbv3Kf
 oNQcYOvzf7k6tToa4cxto4fJkClQqs1H0Ka9Zg47HqPbKbDdpi
 UvveG9moDFAs49MzBBVK0BvWNscs8M98MNzSxkYvy66+TTsPWb
 wkKeLMcrg6krtyEDELck=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 28 August 2013, Sebastian Hesselbarth wrote:
> >
> > This forces zynq to move some initialization our clock code relies on to
> > init_irq(). Also, the current code already takes an approach of
> > doing either common init or machine specific init.
> 
> Soeren,
> 
> you know that patch 16/16 takes care of zynq's clock init?
> 
> It's your own patch you provided from the last RFC. Looking at it, it
> moves  zynq_sclr_init() to .init_irq and removes the call to
> of_clk_init() from zynq_clock_init() which is called by
> zynq_sclr_init().
> 
> Isn't that solving the above issues for mach-zynq?

Please be careful with the patch ordering here. The patch series should
be bisectable, i.e. no patch should ever knowingly break any of the
platforms, with the fix getting added in a later patch.

You should be able to do that by cleaning up all platforms to not
rely on ordering first, then add this patch, and finally remove
the other calls.

	Arnd
