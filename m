Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752208Ab3BYQ1k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 11:27:40 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:55297 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751006Ab3BYQ1j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 11:27:39 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH 24/35] mfd: ab8500: Remove unnecessary 'struct device' declaration
Date: Mon, 25 Feb 2013 16:27:28 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-6-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        sameo@linux.intel.com, linus.walleij@stericsson.com
References: <1360933026-30325-1-git-send-email-lee.jones@linaro.org> <201302251433.36121.arnd@arndb.de> <20130225144904.GM4417@gmail.com>
In-Reply-To: <20130225144904.GM4417@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201302251627.29072.arnd@arndb.de>
X-Provags-ID: V02:K0:W5g8koEYdc/hWCuGEKN1Iw7+CWHZ3Y8whc4Ws3q5TpO
 SMqoNexJQoDnKfr4JP9Ix/jKpZdzAiQOhluwk6/uum9/P2OWn6
 RMA59X2BAQl2mNj7cmXajgy1h85grOjjMb2jCfbYjYWAMEa7eV
 uOImFVa3Nue9adYBOsn52VL9ZXOvcg8OBXl1VaHthJT61vHFEd
 NJKV7oTgMxfsJWBVhcSFWlT+R05QYIcuSHGvfJoSOus4Ozr7zM
 j5wjaxfEROzRJxxPbtycRi3T8tAoawrTre1e9qFgX/BP6Yy5kw
 2/MSAKMO0ynhR96ZRujb+/+Z21hYJceCS8ILeJEgkyXjf331lc
 +05/7uWPu9/8hqn7ON1E=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 25 February 2013, Lee Jones wrote:
> > and others that use 'struct device'. C99 requires that a struct is declared
> > in advance  before you use it in a function declaration.
> 
> Hmm... I wonder why it doesn't complain then?
> 
> I'll remove the patch.

It's only a problem if the file is included before any other header declares
'struct device'. It may well be that this currently never happens, but it's
better to be safe and have a header that can be included in any order:
relying on a specific inclusion order can easily break with 'make randconfig'
turning off specific features that you did not know you relied on.

	Arnd
