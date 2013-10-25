Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754558Ab3JYNFj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 09:05:39 -0400
Received: from mail-ob0-f175.google.com ([209.85.214.175]:50693 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752222Ab3JYNFh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 09:05:37 -0400
Date: Fri, 25 Oct 2013 08:05:34 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH trace-cmd 2/5] build: Install data files without execute
 permissions
Message-ID: <20131025130534.GA24608@thinkpad-t410>
Mail-Followup-To: Steven Rostedt <rostedt@goodmis.org>,
	linux-kernel@vger.kernel.org
References: <1382642074-15567-1-git-send-email-seth.forshee@canonical.com>
 <1382642074-15567-3-git-send-email-seth.forshee@canonical.com>
 <1382689893.8356.2.camel@pippen.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1382689893.8356.2.camel@pippen.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 25, 2013 at 04:31:33AM -0400, Steven Rostedt wrote:
> On Thu, 2013-10-24 at 14:14 -0500, Seth Forshee wrote:
> > diff --git a/Makefile b/Makefile
> > index 1964949..2423038 100644
> > --- a/Makefile
> > +++ b/Makefile
> > @@ -86,7 +86,8 @@ ifeq ($(shell sh -c "python-config --includes > /dev/null 2>&1 && echo y"), y)
> >  	PYTHON_PLUGINS := plugin_python.so
> >  	BUILD_PYTHON := $(PYTHON) $(PYTHON_PLUGINS)
> >  	PYTHON_SO_INSTALL := ctracecmd.install
> > -	PYTHON_PY_INSTALL := event-viewer.install tracecmd.install tracecmdgui.install
> > +	PYTHON_PY_PROGS := event-viewer.install
> > +	PYTHON_PY_LIBS := tracecmd.install tracecmdgui.install
> >  endif
> >  endif # NO_PYTHON
> >  
> > @@ -506,21 +507,32 @@ define do_install
> >  	$(INSTALL) $1 '$(DESTDIR_SQ)$2'
> >  endef
> >  
> > +define do_install_data
> > +	$(print_install)				\
> > +	if [ ! -d '$(DESTDIR_SQ)$2' ]; then		\
> > +		$(INSTALL) -d -m 755 '$(DESTDIR_SQ)$2';	\
> > +	fi;						\
> > +	$(INSTALL) -m 644 $1 '$(DESTDIR_SQ)$2'
> > +endef
> > +
> >  $(PLUGINS_INSTALL): %.install : %.so force
> > -	$(Q)$(call do_install,$<,$(plugin_dir_SQ))
> > +	$(Q)$(call do_install_data,$<,$(plugin_dir_SQ))
> >  
> >  install_plugins: $(PLUGINS_INSTALL)
> >  
> >  $(PYTHON_SO_INSTALL): %.install : %.so force
> > -	$(Q)$(call do_install,$<,$(python_dir_SQ))
> > +	$(Q)$(call do_install_data,$<,$(python_dir_SQ))
> 
> Hmm, I never realized that shared libraries are not suppose to be
> executable. At first I thought this was a mistake, but looking at other
> shared libraries on my system, it seems a lot are not executable
> (although many are, but those may also be made by people like myself who
> thought there were suppose to be).

I don't know that it's a hard and fast rule, but what guidance I found
from searching online was in favor of them not being executable. That
kind of makes sense, since they can't be executed directly (at least not
the ones that trace-cmd installs).

If you disagree, it won't hurt my feelings if you drop those changes, so
long as you keep the ones which makes sure things like .png files aren't
executable ;-)

Thanks,
Seth
