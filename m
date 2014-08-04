Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753231AbaHDWZh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 18:25:37 -0400
Received: from imap.thunk.org ([74.207.234.97]:44232 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753176AbaHDWZe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 18:25:34 -0400
Date: Mon, 4 Aug 2014 18:25:21 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Andy Lutomirski <luto@amacapital.net>
Cc: kvm@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        x86@kernel.org, Daniel Borkmann <dborkman@redhat.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Gleb Natapov <gleb@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        bsd@redhat.com, Andrew Honig <ahonig@google.com>
Subject: Re: [PATCH v5 2/5] random: Add and use arch_get_rng_seed
Message-ID: <20140804222521.GB5263@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Andy Lutomirski <luto@amacapital.net>, kvm@vger.kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
	Kees Cook <keescook@chromium.org>, x86@kernel.org,
	Daniel Borkmann <dborkman@redhat.com>,
	Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
	Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
	Gleb Natapov <gleb@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
	bsd@redhat.com, Andrew Honig <ahonig@google.com>
References: <cover.1406177531.git.luto@amacapital.net>
 <fe3cfe03047cc170bcde652175a00146d290bb20.1406177531.git.luto@amacapital.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fe3cfe03047cc170bcde652175a00146d290bb20.1406177531.git.luto@amacapital.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2014 at 09:57:28PM -0700, Andy Lutomirski wrote:
> Currently, init_std_data contains its own logic for using arch
> random sources.  This replaces that logic with a generic function
> arch_get_rng_seed that allows arch code to supply its own logic.
> The default implementation tries arch_get_random_seed_long and
> arch_get_random_long individually.
> 
> The only functional change here is that random_get_entropy() is used
> unconditionally instead of being used only when the arch sources
> fail.  This may add a tiny amount of security.
> 
> Signed-off-by: Andy Lutomirski <luto@amacapital.net>

Acked-by: Theodore Ts'o <tytso@mit.edu>

							- Ted
