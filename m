Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756930AbaCEXMI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 18:12:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:63720 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752675AbaCEXMF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 18:12:05 -0500
Date: Wed, 5 Mar 2014 18:11:54 -0500
From: Richard Guy Briggs <rgb@redhat.com>
To: Joe Perches <joe@perches.com>
Cc: Josh Boyer <jwboyer@fedoraproject.org>, Eric Paris <eparis@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] audit: remove stray newlines from audit_log_lost messages
Message-ID: <20140305231154.GY16640@madcap2.tricolour.ca>
References: <20140305212955.GV6301@hansolo.jdub.homelinux.org>
 <20140305222703.GW16640@madcap2.tricolour.ca>
 <1394058876.12070.26.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1394058876.12070.26.camel@joe-AO722>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/03/05, Joe Perches wrote:
> On Wed, 2014-03-05 at 17:27 -0500, Richard Guy Briggs wrote:
> > On 14/03/05, Josh Boyer wrote:
> > > Calling audit_log_lost with a \n in the format string leads to extra
> > > newlines in dmesg.  That function will eventually call audit_panic which
> > > uses pr_err with an explicit \n included.  Just make these calls match the
> > > others that lack \n.
> > > 
> > > Reported-by: Jonathan Kamens <jik@kamens.brookline.ma.us>
> > > Signed-off-by: Josh Boyer <jwboyer@fedoraproject.org>
> > 
> > Ack.  queued.
> 
> There's an unnecessary use of a \n in audit_panic too

Thanks, also queued.

> ---
>  kernel/auditsc.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/auditsc.c b/kernel/auditsc.c
> index 7aef2f4..da93d2e 100644
> --- a/kernel/auditsc.c
> +++ b/kernel/auditsc.c
> @@ -1157,7 +1157,7 @@ static void audit_log_execve_info(struct audit_context *context,
>  	 */
>  	buf = kmalloc(MAX_EXECVE_AUDIT_LEN + 1, GFP_KERNEL);
>  	if (!buf) {
> -		audit_panic("out of memory for argv string\n");
> +		audit_panic("out of memory for argv string");
>  		return;
>  	}
>  
> 
> 

- RGB

--
Richard Guy Briggs <rbriggs@redhat.com>
Senior Software Engineer, Kernel Security, AMER ENG Base Operating Systems, Red Hat
Remote, Ottawa, Canada
Voice: +1.647.777.2635, Internal: (81) 32635, Alt: +1.613.693.0684x3545
