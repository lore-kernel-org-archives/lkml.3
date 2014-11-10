Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752078AbaKJDWV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2014 22:22:21 -0500
Received: from mail-bn1on0114.outbound.protection.outlook.com ([157.56.110.114]:14784
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751928AbaKJDWT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2014 22:22:19 -0500
From: Dudley Du <dudl@cypress.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Dudley Du <dudley.dulixin@gmail.com>
CC: "rydberg@euromail.se" <rydberg@euromail.se>,
        "bleung@google.com" <bleung@google.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v9 01/18] input: cyapa: add device resource management
 infrastructure support
Thread-Topic: [PATCH v9 01/18] input: cyapa: add device resource management
 infrastructure support
Thread-Index: AQHP90EHCI8vxLeDaEOSB/XsV6wicZxY2OqAgABCwPA=
Date: Mon, 10 Nov 2014 02:48:08 +0000
Message-ID: <a3a1f76316f24d42b0f95fbda9565d9f@BN1PR06MB070.namprd06.prod.outlook.com>
References: <1415003590-30485-1-git-send-email-dudl@cypress.com>
 <1415003590-30485-2-git-send-email-dudl@cypress.com>
 <20141109212541.GC37384@dtor-ws>
In-Reply-To: <20141109212541.GC37384@dtor-ws>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.95.211.187]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1PR06MB072;
x-exchange-antispam-report-test: UriScan:;
x-exchange-antispam-report-cfa: BCL:0;PCL:0;RULEID:;SRVR:BN1PR06MB072;
x-forefront-prvs: 039178EF4A
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(41574002)(24454002)(51164003)(164054003)(51704005)(199003)(13464003)(189002)(54356999)(50986999)(76176999)(97736003)(99396003)(77156002)(77096003)(76576001)(40100003)(62966003)(33646002)(101416001)(105586002)(107046002)(106116001)(95666004)(106356001)(86362001)(99286002)(2656002)(21056001)(66066001)(120916001)(87936001)(92566001)(46102003)(64706001)(20776003)(4396001)(31966008)(19580395003)(19580405001)(122556002)(108616004)(74316001)(24736002);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR06MB072;H:BN1PR06MB070.namprd06.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: cypress.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks, Dmitry.
I will fix this patch as shown below.
Should I need to fix and resubmit the patches immedaitely or wait for other pathces' comments and submit together?

Thanks,
Dudley

> -----Original Message-----
> From: Dmitry Torokhov [mailto:dmitry.torokhov@gmail.com]
> Sent: 2014?11?10? 5:26
> To: Dudley Du
> Cc: rydberg@euromail.se; Dudley Du; bleung@google.com;
> linux-input@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH v9 01/18] input: cyapa: add device resource management
> infrastructure support
>
> Hi Dudley,
>
> On Mon, Nov 03, 2014 at 04:32:53PM +0800, Dudley Du wrote:
> > Modify cyapa driver to support device resource management infrastructure
> > to reduce the mistakes of resource management.
> > TEST=test on Chromebooks.
> >
> > Signed-off-by: Dudley Du <dudl@cypress.com>
> > ---
> >  drivers/input/mouse/cyapa.c | 48 ++++++++++++++++++---------------------------
> >  1 file changed, 19 insertions(+), 29 deletions(-)
> >
> > diff --git a/drivers/input/mouse/cyapa.c b/drivers/input/mouse/cyapa.c
> > index b409c3d..b3d7a2a 100644
> > --- a/drivers/input/mouse/cyapa.c
> > +++ b/drivers/input/mouse/cyapa.c
> > @@ -409,11 +409,11 @@ static ssize_t cyapa_read_block(struct cyapa *cyapa,
> u8 cmd_idx, u8 *values)
> >  cmd = cyapa_smbus_cmds[cmd_idx].cmd;
> >  len = cyapa_smbus_cmds[cmd_idx].len;
> >  return cyapa_smbus_read_block(cyapa, cmd, len, values);
> > -} else {
> > -cmd = cyapa_i2c_cmds[cmd_idx].cmd;
> > -len = cyapa_i2c_cmds[cmd_idx].len;
> > -return cyapa_i2c_reg_read_block(cyapa, cmd, len, values);
> >  }
> > +
> > +cmd = cyapa_i2c_cmds[cmd_idx].cmd;
> > +len = cyapa_i2c_cmds[cmd_idx].len;
> > +return cyapa_i2c_reg_read_block(cyapa, cmd, len, values);
>
> I am not sure why you are changing this code, it has nothing to do with
> managed resources and the original was just fine.

It's changed just to fix the warning when running the patch checking script.

>
> >  }
> >
> >  /*
> > @@ -762,7 +762,7 @@ static int cyapa_create_input_dev(struct cyapa *cyapa)
> >  if (!cyapa->physical_size_x || !cyapa->physical_size_y)
> >  return -EINVAL;
> >
> > -input = cyapa->input = input_allocate_device();
> > +input = cyapa->input = devm_input_allocate_device(dev);
>
> If you are using devm_* then you do not need to manually cal
> input_free_device() (further down in this fucntion).

Yes, it's correct. It's my mistake to lot the code here.

>
> >  if (!input) {
> >  dev_err(dev, "allocate memory for input device failed\n");
> >  return -ENOMEM;
> > @@ -837,11 +837,9 @@ static int cyapa_probe(struct i2c_client *client,
> >  return -EIO;
> >  }
> >
> > -cyapa = kzalloc(sizeof(struct cyapa), GFP_KERNEL);
> > -if (!cyapa) {
> > -dev_err(dev, "allocate memory for cyapa failed\n");
> > +cyapa = devm_kzalloc(dev, sizeof(struct cyapa), GFP_KERNEL);
> > +if (!cyapa)
> >  return -ENOMEM;
> > -}
> >
> >  cyapa->gen = CYAPA_GEN3;
> >  cyapa->client = client;
> > @@ -856,51 +854,43 @@ static int cyapa_probe(struct i2c_client *client,
> >  ret = cyapa_check_is_operational(cyapa);
> >  if (ret) {
> >  dev_err(dev, "device not operational, %d\n", ret);
> > -goto err_mem_free;
> > +return ret;
> >  }
> >
> >  ret = cyapa_create_input_dev(cyapa);
> >  if (ret) {
> >  dev_err(dev, "create input_dev instance failed, %d\n", ret);
> > -goto err_mem_free;
> > +return ret;
> >  }
> >
> >  ret = cyapa_set_power_mode(cyapa, PWR_MODE_FULL_ACTIVE);
> >  if (ret) {
> >  dev_err(dev, "set active power failed, %d\n", ret);
> > -goto err_unregister_device;
> > +return ret;
> >  }
> >
> >  cyapa->irq = client->irq;
> > -ret = request_threaded_irq(cyapa->irq,
> > -   NULL,
> > -   cyapa_irq,
> > -   IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
> > -   "cyapa",
> > -   cyapa);
> > +ret = devm_request_threaded_irq(dev,
> > +cyapa->irq,
> > +NULL,
> > +cyapa_irq,
> > +IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
> > +"cyapa",
> > +cyapa);
> >  if (ret) {
> >  dev_err(dev, "IRQ request failed: %d\n, ", ret);
> > -goto err_unregister_device;
> > +return ret;
> >  }
> >
> >  return 0;
> > -
> > -err_unregister_device:
> > -input_unregister_device(cyapa->input);
> > -err_mem_free:
> > -kfree(cyapa);
> > -
> > -return ret;
> >  }
> >
> >  static int cyapa_remove(struct i2c_client *client)
> >  {
> >  struct cyapa *cyapa = i2c_get_clientdata(client);
> >
> > -free_irq(cyapa->irq, cyapa);
> > -input_unregister_device(cyapa->input);
> > +disable_irq(cyapa->irq);
> >  cyapa_set_power_mode(cyapa, PWR_MODE_OFF);
> > -kfree(cyapa);
>
> I refer devm* conversions to completely eradicate ->remove() methods.
> I took the liberty to edit the patch a bit, does the version below work
> for you?

Yes, it's working in the below version.
The code in ->remove() method is just to turn the device off, and it can be controlled through open()/close().
Thanks.

>
> Thanks!
>
> --
> Dmitry
>
>
> Input: cyapa - switch to using managed resources
>
> From: Dudley Du <dudley.dulixin@gmail.com>
>
> Use of managed resources simplifies error handling and device removal code.
>
> Signed-off-by: Dudley Du <dudl@cypress.com>
> [Dmitry: added open/close methods so cyapa_remove is no longer needed.]
> Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> ---
>  drivers/input/mouse/cyapa.c |  184 +++++++++++++++++++++++++------------------
>  1 file changed, 105 insertions(+), 79 deletions(-)
>
> diff --git a/drivers/input/mouse/cyapa.c b/drivers/input/mouse/cyapa.c
> index 1d978c7..c84a9eb 100644
> --- a/drivers/input/mouse/cyapa.c
> +++ b/drivers/input/mouse/cyapa.c
> @@ -577,10 +577,13 @@ static int cyapa_set_power_mode(struct cyapa *cyapa,
> u8 power_mode)
>  power = ret & ~PWR_MODE_MASK;
>  power |= power_mode & PWR_MODE_MASK;
>  ret = cyapa_write_byte(cyapa, CYAPA_CMD_POWER_MODE, power);
> -if (ret < 0)
> +if (ret < 0) {
>  dev_err(dev, "failed to set power_mode 0x%02x err = %d\n",
>  power_mode, ret);
> -return ret;
> +return ret;
> +}
> +
> +return 0;
>  }
>
>  static int cyapa_get_query_data(struct cyapa *cyapa)
> @@ -753,16 +756,40 @@ static u8 cyapa_check_adapter_functionality(struct
> i2c_client *client)
>  return ret;
>  }
>
> +static int cyapa_open(struct input_dev *input)
> +{
> +struct cyapa *cyapa = input_get_drvdata(input);
> +struct i2c_client *client = cyapa->client;
> +int error;
> +
> +error = cyapa_set_power_mode(cyapa, PWR_MODE_FULL_ACTIVE);
> +if (error) {
> +dev_err(&client->dev, "set active power failed: %d\n", error);
> +return error;
> +}
> +
> +enable_irq(client->irq);
> +return 0;
> +}
> +
> +static void cyapa_close(struct input_dev *input)
> +{
> +struct cyapa *cyapa = input_get_drvdata(input);
> +
> +disable_irq(cyapa->client->irq);
> +cyapa_set_power_mode(cyapa, PWR_MODE_OFF);
> +}
> +
>  static int cyapa_create_input_dev(struct cyapa *cyapa)
>  {
>  struct device *dev = &cyapa->client->dev;
> -int ret;
>  struct input_dev *input;
> +int error;
>
>  if (!cyapa->physical_size_x || !cyapa->physical_size_y)
>  return -EINVAL;
>
> -input = cyapa->input = input_allocate_device();
> +input = devm_input_allocate_device(dev);
>  if (!input) {
>  dev_err(dev, "allocate memory for input device failed\n");
>  return -ENOMEM;
> @@ -775,6 +802,9 @@ static int cyapa_create_input_dev(struct cyapa *cyapa)
>  input->id.product = 0;  /* means any product in eventcomm. */
>  input->dev.parent = &cyapa->client->dev;
>
> +input->open = cyapa_open;
> +input->close = cyapa_close;
> +
>  input_set_drvdata(input, cyapa);
>
>  __set_bit(EV_ABS, input->evbit);
> @@ -802,34 +832,24 @@ static int cyapa_create_input_dev(struct cyapa *cyapa)
>  __set_bit(INPUT_PROP_BUTTONPAD, input->propbit);
>
>  /* handle pointer emulation and unused slots in core */
> -ret = input_mt_init_slots(input, CYAPA_MAX_MT_SLOTS,
> -  INPUT_MT_POINTER | INPUT_MT_DROP_UNUSED);
> -if (ret) {
> -dev_err(dev, "allocate memory for MT slots failed, %d\n", ret);
> -goto err_free_device;
> +error = input_mt_init_slots(input, CYAPA_MAX_MT_SLOTS,
> +    INPUT_MT_POINTER | INPUT_MT_DROP_UNUSED);
> +if (error) {
> +dev_err(dev, "failed to initialize MT slots: %d\n", error);
> +return error;
>  }
>
> -/* Register the device in input subsystem */
> -ret = input_register_device(input);
> -if (ret) {
> -dev_err(dev, "input device register failed, %d\n", ret);
> -goto err_free_device;
> -}
> +cyapa->input = input;
>  return 0;
> -
> -err_free_device:
> -input_free_device(input);
> -cyapa->input = NULL;
> -return ret;
>  }
>
>  static int cyapa_probe(struct i2c_client *client,
>         const struct i2c_device_id *dev_id)
>  {
> -int ret;
> -u8 adapter_func;
> -struct cyapa *cyapa;
>  struct device *dev = &client->dev;
> +struct cyapa *cyapa;
> +u8 adapter_func;
> +int error;
>
>  adapter_func = cyapa_check_adapter_functionality(client);
>  if (adapter_func == CYAPA_ADAPTER_FUNC_NONE) {
> @@ -837,11 +857,9 @@ static int cyapa_probe(struct i2c_client *client,
>  return -EIO;
>  }
>
> -cyapa = kzalloc(sizeof(struct cyapa), GFP_KERNEL);
> -if (!cyapa) {
> -dev_err(dev, "allocate memory for cyapa failed\n");
> +cyapa = devm_kzalloc(dev, sizeof(struct cyapa), GFP_KERNEL);
> +if (!cyapa)
>  return -ENOMEM;
> -}
>
>  cyapa->gen = CYAPA_GEN3;
>  cyapa->client = client;
> @@ -852,66 +870,61 @@ static int cyapa_probe(struct i2c_client *client,
>  /* i2c isn't supported, use smbus */
>  if (adapter_func == CYAPA_ADAPTER_FUNC_SMBUS)
>  cyapa->smbus = true;
> +
>  cyapa->state = CYAPA_STATE_NO_DEVICE;
> -ret = cyapa_check_is_operational(cyapa);
> -if (ret) {
> -dev_err(dev, "device not operational, %d\n", ret);
> -goto err_mem_free;
> -}
>
> -ret = cyapa_create_input_dev(cyapa);
> -if (ret) {
> -dev_err(dev, "create input_dev instance failed, %d\n", ret);
> -goto err_mem_free;
> +error = cyapa_check_is_operational(cyapa);
> +if (error) {
> +dev_err(dev, "device not operational, %d\n", error);
> +return error;
>  }
>
> -ret = cyapa_set_power_mode(cyapa, PWR_MODE_FULL_ACTIVE);
> -if (ret) {
> -dev_err(dev, "set active power failed, %d\n", ret);
> -goto err_unregister_device;
> +/* Power down the device until we need it */
> +error = cyapa_set_power_mode(cyapa, PWR_MODE_OFF);
> +if (error) {
> +dev_err(dev, "failed to quiesce the device: %d\n", error);
> +return error;
>  }
>
> -cyapa->irq = client->irq;
> -ret = request_threaded_irq(cyapa->irq,
> -   NULL,
> -   cyapa_irq,
> -   IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
> -   "cyapa",
> -   cyapa);
> -if (ret) {
> -dev_err(dev, "IRQ request failed: %d\n, ", ret);
> -goto err_unregister_device;
> +error = cyapa_create_input_dev(cyapa);
> +if (error)
> +return error;
> +
> +error = devm_request_threaded_irq(dev, client->irq,
> +  NULL, cyapa_irq,
> +  IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
> +  "cyapa", cyapa);
> +if (error) {
> +dev_err(dev, "IRQ request failed: %d\n, ", error);
> +return error;
>  }
>
> -return 0;
> -
> -err_unregister_device:
> -input_unregister_device(cyapa->input);
> -err_mem_free:
> -kfree(cyapa);
> +/* Disable IRQ until the device is opened */
> +disable_irq(client->irq);
>
> -return ret;
> -}
> -
> -static int cyapa_remove(struct i2c_client *client)
> -{
> -struct cyapa *cyapa = i2c_get_clientdata(client);
> -
> -free_irq(cyapa->irq, cyapa);
> -input_unregister_device(cyapa->input);
> -cyapa_set_power_mode(cyapa, PWR_MODE_OFF);
> -kfree(cyapa);
> +/* Register the device in input subsystem */
> +error = input_register_device(cyapa->input);
> +if (error) {
> +dev_err(dev, "failed to register input device: %d\n", error);
> +return error;
> +}
>
>  return 0;
>  }
>
>  static int __maybe_unused cyapa_suspend(struct device *dev)
>  {
> -int ret;
> +struct i2c_client *client = to_i2c_client(dev);
> +struct cyapa *cyapa = i2c_get_clientdata(client);
> +struct input_dev *input = cyapa->input;
>  u8 power_mode;
> -struct cyapa *cyapa = dev_get_drvdata(dev);
> +int error;
> +
> +error = mutex_lock_interruptible(&input->mutex);
> +if (error)
> +return error;
>
> -disable_irq(cyapa->irq);
> +disable_irq(client->irq);
>
>  /*
>   * Set trackpad device to idle mode if wakeup is allowed,
> @@ -919,28 +932,42 @@ static int __maybe_unused cyapa_suspend(struct device
> *dev)
>   */
>  power_mode = device_may_wakeup(dev) ? PWR_MODE_IDLE
>      : PWR_MODE_OFF;
> -ret = cyapa_set_power_mode(cyapa, power_mode);
> -if (ret < 0)
> -dev_err(dev, "set power mode failed, %d\n", ret);
> +error = cyapa_set_power_mode(cyapa, power_mode);
> +if (error)
> +dev_err(dev, "resume: set power mode to %d failed: %d\n",
> + power_mode, error);
>
>  if (device_may_wakeup(dev))
>  cyapa->irq_wake = (enable_irq_wake(cyapa->irq) == 0);
> +
> +mutex_unlock(&input->mutex);
> +
>  return 0;
>  }
>
>  static int __maybe_unused cyapa_resume(struct device *dev)
>  {
> -int ret;
> -struct cyapa *cyapa = dev_get_drvdata(dev);
> +struct i2c_client *client = to_i2c_client(dev);
> +struct cyapa *cyapa = i2c_get_clientdata(client);
> +struct input_dev *input = cyapa->input;
> +u8 power_mode;
> +int error;
> +
> +mutex_lock(&input->mutex);
>
>  if (device_may_wakeup(dev) && cyapa->irq_wake)
>  disable_irq_wake(cyapa->irq);
>
> -ret = cyapa_set_power_mode(cyapa, PWR_MODE_FULL_ACTIVE);
> -if (ret)
> -dev_warn(dev, "resume active power failed, %d\n", ret);
> +power_mode = input->users ? PWR_MODE_FULL_ACTIVE : PWR_MODE_OFF;
> +error = cyapa_set_power_mode(cyapa, PWR_MODE_FULL_ACTIVE);
> +if (error)
> +dev_warn(dev, "resume: set power mode to %d failed: %d\n",
> + power_mode, error);
>
>  enable_irq(cyapa->irq);
> +
> +mutex_unlock(&input->mutex);
> +
>  return 0;
>  }
>
> @@ -960,7 +987,6 @@ static struct i2c_driver cyapa_driver = {
>  },
>
>  .probe = cyapa_probe,
> -.remove = cyapa_remove,
>  .id_table = cyapa_id_table,
>  };
>

This message and any attachments may contain Cypress (or its subsidiaries) confidential information. If it has been received in error, please advise the sender and immediately delete this message.
