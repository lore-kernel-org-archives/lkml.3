Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755853Ab3GKKJD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 06:09:03 -0400
Received: from cpsmtpb-ews09.kpnxchange.com ([213.75.39.14]:60988 "EHLO
	cpsmtpb-ews09.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754845Ab3GKKJB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 06:09:01 -0400
Message-ID: <1373537338.9708.18.camel@x61.thuisdomein>
Subject: Re: [Xen-devel] [PATCH] xen: remove unused Kconfig parameter
From: Paul Bolle <pebolle@tiscali.nl>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Matt Wilson <msw@amazon.com>,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>,
        jeremy@goop.org, xen-devel@lists.xensource.com, x86@kernel.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, mingo@redhat.com,
        tglx@linutronix.de
Date: Thu, 11 Jul 2013 12:08:58 +0200
In-Reply-To: <f5d6bd67-7464-4932-a7ca-6026fe534fc7@email.android.com>
References: <1373264904-27053-1-git-send-email-michael.opdenacker@free-electrons.com>
	 <20130708192854.GF4927@phenom.dumpdata.com>
	 <20130708193457.GA6926@u109add4315675089e695.ant.amazon.com>
	 <51DB2134.9040909@zytor.com> <20130708205834.GA481@pd.tnic>
	 <1373326534.1438.10.camel@x61.thuisdomein>
	 <f5d6bd67-7464-4932-a7ca-6026fe534fc7@email.android.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 11 Jul 2013 10:08:58.0986 (UTC) FILETIME=[A9010CA0:01CE7E1E]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-07-08 at 20:26 -0400, Konrad Rzeszutek Wilk wrote:
> Could you explain to me please why the check in the scripts is
> superfluous?

The discussion has since moved on a bit, but I haven't answered this
question yet.

The check grub2 currently performs in one of its configuration scripts
is (reformatted):
    if (grep -qx "CONFIG_XEN_DOM0=y" "${config}" 2> /dev/null ||
        grep -qx "CONFIG_XEN_PRIVILEGED_GUEST=y" "${config}" 2> /dev/null);
    then echo -n "$i " ;
    fi

But the Kconfig entry for XEN_PRIVILEGED_GUEST reads: 
    # Dummy symbol since people have come to rely on the PRIVILEGED_GUEST
    # name in tools.
    config XEN_PRIVILEGED_GUEST
            def_bool XEN_DOM0

In other words: CONFIG_XEN_PRIVILEGED_GUEST should always be equal to
CONFIG_XEN_DOM0. So the two grep commands should always both evaluate to
true or both evaluate to false. One of these two commands can safely be
dropped.

Another consequence is that dropping XEN_PRIVILEGED_GUEST doesn't break
this configuration script. It will still behave as it does now.

(Whether that script should grep for Kconfig macros in the first place
is another discussion.)


Paul Bolle

