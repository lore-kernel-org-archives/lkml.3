Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755787Ab3HYSaE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Aug 2013 14:30:04 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:65119 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755570Ab3HYSaB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Aug 2013 14:30:01 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Frantisek Hrbata <fhrbata@redhat.com>
Subject: Re: [RFC PATCH 3/4] gcov: compile specific gcov implementation based on gcc version
Date: Sun, 25 Aug 2013 20:29:45 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, jstancek@redhat.com,
        keescook@chromium.org, rusty@rustcorp.com.au,
        linux-arch@vger.kernel.org, mgahagan@redhat.com, agospoda@redhat.com
References: <1377247176-13537-1-git-send-email-fhrbata@redhat.com> <52177DE8.6090704@linux.vnet.ibm.com> <20130824194413.GB2365@localhost.localdomain>
In-Reply-To: <20130824194413.GB2365@localhost.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201308252029.45375.arnd@arndb.de>
X-Provags-ID: V02:K0:8ioXY2sdvDZ1H7cz++REHSCAjyvOjc31FByZ/A5iG8k
 ilSdlZzTjn1D2If+vp4R7D0Vhv1bpqEyDj0uTkDCAV9PWBWf8Y
 WUDPE96w/7WlvmkE2kgx7D3cO6x5wgaW2NShEB2Gpxs8Q8F94s
 yGf9djPFVQsflfgZrcIVCrSYGeqW2eMDe1asgmxu1FmoELSv8z
 w3J/hHFXUwsnFIcf5dilHzrpDmckLH9Z28TpX8mIPYdJSivXiE
 CaAqdZKDUgSq7FzTtZvqpPNDd0IEQgIU0uRysQUlMlXyb1LijY
 k3O9CBtxuQzgCgN0npy/P0eSKHnbWWmrqcsaB0E5UETiZzfYyM
 hmfmLUtsndYiPlpQznhQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 24 August 2013, Frantisek Hrbata wrote:
> If I understand it correctly, this would mean that you will be able to use only
> one implementation of gcov format at the time. Meaning you will be able to get
> coverage data for module, but not for kernel if it was compiled with different
> gcc(gcda format). This is probably ok if you work only on your module, but I'm
> not sure this is generally the right approach. In this case I would probably
> rather see some support for more gcov formats at the same time(e.g. set of
> callback operations per gcov version). Again I'm probably missing something, but
> I still cannot see reason why to add such feature. If you want gcov support just
> compile your kernel and modules with the same gcc version(gcda format). But if
> this is really needed maybe it would be better to consider some parallel support
> for more gcov formats based on the gcov_info version.

The kernel is always built with exactly one version, including all the modules.
I don't see any reason whatsoever to support externally built modules with gcov,
in particular when they are not built with the system compiler.

	Arnd
