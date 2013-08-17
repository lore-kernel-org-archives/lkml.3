Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754031Ab3HQQ4W (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Aug 2013 12:56:22 -0400
Received: from smtp.snhosting.dk ([87.238.248.203]:52432 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753669Ab3HQQ4V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Aug 2013 12:56:21 -0400
Date: Sat, 17 Aug 2013 18:56:18 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Max Filippov <jcmvbkbc@gmail.com>
Cc: Guenter Roeck <linux@roeck-us.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chris Zankel <chris@zankel.net>
Subject: Re: Linux kernel cross-compilers
Message-ID: <20130817165618.GA14751@merkur.ravnborg.org>
References: <520C9A39.3030808@roeck-us.net> <CAMo8BfKyqZYMkh96wyZSpYUpXwqFQZkco=XgtjUrNG-jSzW5pA@mail.gmail.com> <20130816054823.GB28445@thor.bakeyournoodle.com> <CAMo8Bf+veq_DU7-hnB0yySy6YWpwU2TYx3U9e89c_m8Mv9Cv5w@mail.gmail.com> <520DD9CA.90305@roeck-us.net> <CAMo8BfLvVk+2CyQD28otU265J4rvbt0Eg11Vqr4u4zjKjrTanw@mail.gmail.com> <520DEF05.9030803@roeck-us.net> <CAMo8BfKWFGxr6a48tFqGCourOcWOTO9rmCHy3Q05jR_QEuq=Cg@mail.gmail.com> <520E48A7.3050401@roeck-us.net> <CAMo8BfK8pwMy7MPqrhRH2XPjfgu+H2pGhxBjbxKqnHwficKNFw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMo8BfK8pwMy7MPqrhRH2XPjfgu+H2pGhxBjbxKqnHwficKNFw@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >
> > I found out the root source: SHELL is set the /bin/sh, which on the failing
> > system points to /bin/dash (default in Ubuntu, or at least it used to be).
> > dash apparently has a built-in version of echo which does not understand
> > '-e'.
> > Oh well.
> 
> Cool. OTOH I don't think that we need to -e to output __XTENSA_EB__.
> Will send a patch for that.

Could you please take a look at the other places that uses "echo -e".
At least one usage inarch/x86/Makefiel looks questionable.
grep did not turn up many uses.

	Sam
