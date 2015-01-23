Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754544AbbAWJue (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 04:50:34 -0500
Received: from mail-pd0-f174.google.com ([209.85.192.174]:62773 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752271AbbAWJua (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 04:50:30 -0500
Date: Fri, 23 Jan 2015 01:50:26 -0800
From: Jeremiah Mahler <jmmahler@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Dudley Du <dudl@cypress.com>, dmitry.torokhov@gmail.com,
        rydberg@euromail.se, bleung@google.com, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] input: cyapa: fix sparse warning issue of incorrect
 type in assiggment
Message-ID: <20150123095026.GA9314@hudson.localdomain>
Mail-Followup-To: Jeremiah Mahler <jmmahler@gmail.com>,
	Dan Carpenter <dan.carpenter@oracle.com>,
	Dudley Du <dudl@cypress.com>, dmitry.torokhov@gmail.com,
	rydberg@euromail.se, bleung@google.com, linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <1421909406-1240-1-git-send-email-dudl@cypress.com>
 <20150122093129.GA7133@hudson.localdomain>
 <20150122095453.GL6507@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150122095453.GL6507@mwanda>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 22, 2015 at 12:54:53PM +0300, Dan Carpenter wrote:
> On Thu, Jan 22, 2015 at 01:31:29AM -0800, Jeremiah Mahler wrote:
> > I wasn't able to reproduce the sparse warning.  Was it for a specific
> > architecture?  Perhaps include a link to the email sent by the kbuild
> > test robot.
> 
> You need to add a "CF=-D__CHECK_ENDIAN__" to turn these on.
> 
> make C=2 CF=-D__CHECK_ENDIAN__
> 
> http://lwn.net/Articles/205624/
> 
> regards,
> dan carpenter
> 

Even with __CHECK_ENDIAN__ I wasn't able to reproduce these errors
straight away because this fix is already in next.  But once reverted
they appeared and the patch does fix all of them.

  jeri@hudson:~/linux-next$ git checkout 2be7256fe7f
  jeri@hudson:~/linux-next$ git reset --hard HEAD~1
  jeri@hudson:~/linux-next$ make C=1 "CF=-D__CHECK_ENDIAN__"
  (errors ...)

-- 
- Jeremiah Mahler
