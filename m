Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752447AbaFBUQX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 16:16:23 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:55939 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751828AbaFBUQW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 16:16:22 -0400
MIME-Version: 1.0
In-Reply-To: <20140602073904.GQ17724@mwanda>
References: <1401629315-18843-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
	<20140601203703.GO17724@mwanda>
	<CAFo99gZEDeXZvdmkESrQ0CSME4wEZ3WSEJmJ-FoJVXOhK=zzcQ@mail.gmail.com>
	<20140602073904.GQ17724@mwanda>
Date: Mon, 2 Jun 2014 22:16:21 +0200
Message-ID: <CAFo99gY=oXJX9ENbZwd5U9xWir1Y66mJLok7UCsd0YBtTjSNog@mail.gmail.com>
Subject: Re: [PATCH] staging: rtl8192u: r8192U_core.c: Cleaning up
 uninitialized variables
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Xenia Ragiadakou <burzalodowa@gmail.com>,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
        Ana Rey <anarey@gmail.com>, Teodora Baluta <teobaluta@gmail.com>,
        Andrea Merello <andrea.merello@gmail.com>, devel@driverdev.osuosl.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dan!


Now this is a bad example because there is nothing really wrong, and I
could not find the original error log :-(


But i get for the testing variable:
drivers/staging/rtl8192u/r8192U_core.c : 4747] :  (style) Variable
'testing' is assigned a value that is never used.


And for the this file i now get:

drivers/staging/rtl8192u/r8192U_core.c : 1014] :  (style) Variable
'ret' is assigned a value that is never used.
drivers/staging/rtl8192u/r8192U_core.c : 1258] :  (error) Possible
null pointer dereference :  dev
drivers/staging/rtl8192u/r8192U_core.c : 1411] :  (style) Variable
'rate_config' is assigned a value that is never used.
drivers/staging/rtl8192u/r8192U_core.c : 1908] :  (portability)
'oldaddr' is of type 'void *'. When using void pointers in
calculations, the behaviour is undefined.
drivers/staging/rtl8192u/r8192U_core.c : 1959] :  (style) Unused variable :  i
drivers/staging/rtl8192u/r8192U_core.c : 2040] ->
[drivers/staging/rtl8192u/r8192U.h : 1129] :  (style, inconclusive)
The struct 'r8192_priv' hides a typedef with the same name.
drivers/staging/rtl8192u/r8192U_core.c : 2041] ->
[drivers/staging/rtl8192u/r8192U_core.c : 2048] :  (warning) Possible
null pointer dereference :  priv - otherwise it is redundant to check
it against null.




But why not test yourself, see:


http://cppcheck.sourceforge.net/


Appropriate arguments to start with are:
cppcheck --force --quiet  --enable=all drivers/staging/rtl8192u/r8192U_core.c


Best regards
Rickard Strandqvist


2014-06-02 9:39 GMT+02:00 Dan Carpenter <dan.carpenter@oracle.com>:
> On Sun, Jun 01, 2014 at 11:05:39PM +0200, Rickard Strandqvist wrote:
>> Hi Dan
>>
>> I agree, this looks strange.
>> Have been looking for a while in history with, to see if the code has
>> been removed. I start my search using cppcheck for over three months
>> ago.
>> But could not find anything. Sorry about that :-(
>>
>> But I'll make a patch that completely removes testing variable then instead?
>
> Yes.  Btw, what do the cppcheck error messages for this look like
> anyway?
>
> regards,
> dan carpenter
>
