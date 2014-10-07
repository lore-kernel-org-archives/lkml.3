Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755278AbaJGWG5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 18:06:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58219 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751056AbaJGWG4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 18:06:56 -0400
From: Paul Moore <pmoore@redhat.com>
To: Richard Guy Briggs <rgb@redhat.com>, sgrubb@redhat.com
Cc: Eric Paris <eparis@redhat.com>, linux-audit@redhat.com,
        linux-kernel@vger.kernel.org, ebiederm@xmission.com, serge@hallyn.com,
        keescook@chromium.org
Subject: Re: [RFC][PATCH] audit: log join and part events to the read-only multicast log socket
Date: Tue, 07 Oct 2014 18:06:51 -0400
Message-ID: <3117997.iSq2b2nm2S@sifl>
Organization: Red Hat
User-Agent: KMail/4.14.1 (Linux/3.16.1-gentoo; KDE/4.14.1; x86_64; ; )
In-Reply-To: <20141007193951.GZ1992@madcap2.tricolour.ca>
References: <30ef5c1ba42b52953e5684a0322975c3f0fadc77.1412706089.git.rgb@redhat.com> <1412708594.3333.94.camel@localhost> <20141007193951.GZ1992@madcap2.tricolour.ca>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, October 07, 2014 03:39:51 PM Richard Guy Briggs wrote:
> I also thought of moving audit_log_task() from auditsc.c to audit.c
> and using that.  For that matter, both audit_log_task() and
> audit_log_task_info() could use audit_log_session_info(), but they are
> in slightly different order of keywords which will upset sgrubb's
> parser.

A bit of an aside from the patch, but in my opinion the parser should be made 
a bit more robust so that it can handle fields in any particular order.  I 
agree that having fields in a "canonical ordering" is helpful, both for tools 
and people, but the tools shouldn't require it in my opinion.

Steve, why exactly can't the userspace parser handle fields in any order?  How 
difficult would it be to fix?

-- 
paul moore
security and virtualization @ redhat

