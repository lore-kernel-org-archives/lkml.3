Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756929Ab3DADzn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Mar 2013 23:55:43 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:60640 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756242Ab3DADzm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Mar 2013 23:55:42 -0400
Message-ID: <1364788537.8705.10.camel@ubuntu>
Subject: Re: [PATCH] checkpatch: do not exit in main process subroutine
From: Joe Perches <joe@perches.com>
To: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
Cc: Andy Whitcroft <apw@canonical.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Sun, 31 Mar 2013 21:55:37 -0600
In-Reply-To: <5156BECE.9070701@huawei.com>
References: <5153BC45.807@huawei.com> <5156BECE.9070701@huawei.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-03-30 at 18:30 +0800, zhangwei(Jovi) wrote:
> On 2013/3/28 11:43, zhangwei(Jovi) wrote:
> > Currently checkpatch program exit when process empty file,
> > This will cause issue when @ARGV include many files ready to check.
[]
> > diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> > @@ -3634,19 +3634,19 @@ sub process {
> >  	# If we have no input at all, then there is nothing to report on
> >  	# so just keep quiet.
> >  	if ($#rawlines == -1) {
> > -		exit(0);
> > +		return $clean;
> >  	}

I think instead this should be something like adding

	if (!is_patch && $#rawlines == -1) {
		return $clean;
	}

though maybe expecting checkpatch to avoid empty files
when fed a directory list is unrealistic.


