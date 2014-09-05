Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751782AbaIEEI6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 00:08:58 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:59507 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750762AbaIEEI5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 00:08:57 -0400
X-Sasl-enc: quHYDhEdoD3/wr1oXYqWGPfKc8VMVsGRrv389SNH12G0 1409890135
Message-ID: <1409890133.10788.23.camel@localhost>
Subject: Re: [PATCH] kernel: add support for gcc 5
From: Hannes Frederic Sowa <hannes@stressinduktion.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Joe Perches <joe@perches.com>, Aaro Koskinen <aaro.koskinen@iki.fi>,
        akpm@linuxfoundation.org, mingo@kernel.org,
        linux-kernel@vger.kernel.org
Date: Fri, 05 Sep 2014 06:08:53 +0200
In-Reply-To: <54092FE0.3030004@oracle.com>
References: <1409845039-5751-1-git-send-email-sasha.levin@oracle.com>
		 <20140904212535.GA5059@drone.musicnaut.iki.fi>
		 <1409870628.2310799.163815377.623F33D2@webmail.messagingengine.com>
	 <1409874455.2770.26.camel@joe-AO725> <54092FE0.3030004@oracle.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-3.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Do, 2014-09-04 at 23:37 -0400, Sasha Levin wrote:
> On 09/04/2014 07:47 PM, Joe Perches wrote:
> > On Fri, 2014-09-05 at 00:43 +0200, Hannes Frederic Sowa wrote:
> >> > Most statements are already depending on GCC_VERSION, maybe we can just
> >> > unify all gcc specific headers to one, still trying to keep the file
> >> > organized? ;)
> > Maybe something like:
> > 
> > gnu development of gcc will be more frequent and the use of
> > compiler-gcc<major>.h likely will not be convenient anymore.
> > 
> > Integrate the individual compiler-gcc<major>.h files into
> > compiler-gcc.h.
> 
> Please no. We have a similar file we maintain in our team that's supposed to
> do something very similar for kernel versions. It goes all the way back to
> 2.6.9 and it's a *horrible* mess.
> 
> This is how compiler-gcc.h will end up looking in a while.

Something along these lines? We can make '4' a macro describing it
references the latest possible compiler-gccX.h file.

--- a/include/linux/compiler-gcc.h
+++ b/include/linux/compiler-gcc.h
@@ -103,7 +103,12 @@
 #define __gcc_header(x) #x
 #define _gcc_header(x) __gcc_header(linux/compiler-gcc##x.h)
 #define gcc_header(x) _gcc_header(x)
+
+#if __GNUC__ > 4
+#include gcc_header(4)
+#else
 #include gcc_header(__GNUC__)
+#endif
 
 #if !defined(__noclone)
 #define __noclone      /* not needed */


I still think we should start chaining newer gcc header files to
deduplicate the content. What do you think?

Bye,
Hannes


