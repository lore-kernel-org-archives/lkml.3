Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752525AbbAPPa5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 10:30:57 -0500
Received: from cpsmtpb-ews06.kpnxchange.com ([213.75.39.9]:55197 "EHLO
	cpsmtpb-ews06.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751427AbbAPPa4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 10:30:56 -0500
Message-ID: <1421422253.8562.8.camel@x220>
Subject: Re: [PATCH] mm/page_owner: Fix memory leak
From: Paul Bolle <pebolle@tiscali.nl>
To: Valentin Ilie <valentin.ilie@gmail.com>
Cc: iamjoonsoo.kim@lge.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org
Date: Fri, 16 Jan 2015 16:30:53 +0100
In-Reply-To: <1421420621.8562.1.camel@x220>
References: <1421410284-23776-1-git-send-email-valentin.ilie@gmail.com>
	 <1421420621.8562.1.camel@x220>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Jan 2015 15:30:53.0208 (UTC) FILETIME=[6A06F180:01D031A1]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(I dislike it when people set a trap for me, so on second thought I tell
you what I should have added right away.) 

On Fri, 2015-01-16 at 16:03 +0100, Paul Bolle wrote:
> On Fri, 2015-01-16 at 14:11 +0200, Valentin Ilie wrote:
> > Call kfree on list2 after using it.
> > 
> > Signed-off-by: Valentin Ilie <valentin.ilie@gmail.com>
> > ---
> >  tools/vm/page_owner_sort.c | 2 ++
> >  1 file changed, 2 insertions(+)
> > 
> > diff --git a/tools/vm/page_owner_sort.c b/tools/vm/page_owner_sort.c
> > index 77147b4..92292d5 100644
> > --- a/tools/vm/page_owner_sort.c
> > +++ b/tools/vm/page_owner_sort.c
> > @@ -139,6 +139,8 @@ int main(int argc, char **argv)
> >  
> >  	for (i = 0; i < count; i++)
> >  		fprintf(fout, "%d times:\n%s\n", list2[i].num, list2[i].txt);
> > +	
> 
> Checkpatch would have caught the tab you added here.
> 
> > +	kfree(list2);
> 
> You didn't even compile this, did you?
>  
> >  	return 0;
> >  }

Before you resend: what happens to the resources of a userspace program
when its main() returns?


Paul Bolle

