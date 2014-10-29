Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933010AbaJ2Nwp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 09:52:45 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:52878 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932837AbaJ2Nwo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 09:52:44 -0400
From: Paul Moore <paul@paul-moore.com>
To: stable@vger.kernel.org
Cc: Richard Guy Briggs <rgb@redhat.com>, linux-audit@redhat.com,
        linux-kernel@vger.kernel.org, sgrubb@redhat.com
Subject: Re: [PATCH][STABLE] audit: correct AUDIT_GET_FEATURE return message type
Date: Wed, 29 Oct 2014 09:52:39 -0400
Message-ID: <6874821.5ihWZEPEQR@sifl>
User-Agent: KMail/4.14.1 (Linux/3.16.1-gentoo; KDE/4.14.1; x86_64; ; )
In-Reply-To: <20141029133506.GN26201@madcap2.tricolour.ca>
References: <20141029133506.GN26201@madcap2.tricolour.ca>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, October 29, 2014 09:35:06 AM Richard Guy Briggs wrote:
> When an AUDIT_GET_FEATURE message is sent from userspace to the kernel, it
> should reply with a message tagged as an AUDIT_GET_FEATURE type with a
> struct audit_feature.  The current reply is a message tagged as an
> AUDIT_GET type with a struct audit_feature.
> 
> This appears to have been a cut-and-paste-eo in commit b0fed40.
> 
> Reported-by: Steve Grubb <sgrubb@redhat.com>
> Cc: stable@vger.kernel.org # v3.13-rc1
> Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> ---
>  kernel/audit.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)

Acked-by: Paul Moore <paul@paul-moore.com>

> diff --git a/kernel/audit.c b/kernel/audit.c
> index d20f00f..3a80abb 100644
> --- a/kernel/audit.c
> +++ b/kernel/audit.c
> @@ -724,7 +724,7 @@ static int audit_get_feature(struct sk_buff *skb)
> 
>  	seq = nlmsg_hdr(skb)->nlmsg_seq;
> 
> -	audit_send_reply(skb, seq, AUDIT_GET, 0, 0, &af, sizeof(af));
> +	audit_send_reply(skb, seq, AUDIT_GET_FEATURE, 0, 0, &af, sizeof(af));
> 
>  	return 0;
>  }

-- 
paul moore
www.paul-moore.com

