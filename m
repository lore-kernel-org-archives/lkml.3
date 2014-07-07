Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751607AbaGGT6v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 15:58:51 -0400
Received: from mga02.intel.com ([134.134.136.20]:52130 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750809AbaGGT6s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 15:58:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,620,1400050800"; 
   d="scan'208";a="569560620"
Message-ID: <53BAFBFB.60709@linux.intel.com>
Date: Mon, 07 Jul 2014 12:58:51 -0700
From: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Jonathan Cameron <jic23@kernel.org>
CC: Reyad Attiyat <reyad.attiyat@gmail.com>, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 3/4] iio: hid-sensor-magn-3d: Scan for usage attributes
 before setting up iio channels
References: <1404097119-19922-1-git-send-email-reyad.attiyat@gmail.com> <1404097119-19922-4-git-send-email-reyad.attiyat@gmail.com> <53BACE70.3070901@kernel.org>
In-Reply-To: <53BACE70.3070901@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Reyad,

I see panic in the probe function. Can you review your logic?
It is possible that platforms don't have all attributes, so looks
like the probe is returnning with error.

On 07/07/2014 09:44 AM, Jonathan Cameron wrote:
> On 30/06/14 03:58, Reyad Attiyat wrote:
>> Scan for and count the HID usage attributes supported by the driver.
>> This allows for the driver to only setup the IIO channels for the
>> sensor usages present in the HID USB reports.
>>
>> Signed-off-by: Reyad Attiyat <reyad.attiyat@gmail.com>
>> ---
> There should be an explanation here of what has changed from one version
> to the
> next.
>
> The patches should have been run through checkpatch.pl (at least one
> place below
> indicates that didn't happen).
>
> Mostly little bits left.  Now I would definitely like an ack or reviewed-by
> from Srinivas for this one if at all possible.

[    7.653643] BUG: unable to handle kernel NULL pointer dereference at 
0000000000000031
[    7.653648] IP: [<ffffffff81242cee>] sysfs_remove_link+0xe/0x30
[    7.653650] PGD 13d0fd067 PUD 147cbd067 PMD 0
[    7.653652] Oops: 0000 [#1] SMP
[    7.653676] Modules linked in: hid_sensor_magn_3d(+) 
hid_sensor_rotation hid_sensor_gyro_3d hid_sensor_trigger 
industrialio_triggered_buffer kfifo_buf industrialio asix(+) usb_storage 
hid_sensor_iio_common usbnet usbhid mii joydev usbserial(+) hid_rmi(+) 
intel_rapl x86_pkg_temp_thermal uvcvideo intel_powerclamp coretemp 
kvm_intel videobuf2_vmalloc videobuf2_memops videobuf2_core iwlwifi kvm 
v4l2_common videodev hid_multitouch hid_sensor_hub ppdev btusb 
crct10dif_pclmul cfg80211 crc32_pclmul ghash_clmulni_intel aesni_intel 
aes_x86_64 lrw gf128mul glue_helper ablk_helper cryptd mei_me(+) mei 
serio_raw lpc_ich(+) i915(+) snd_hda_codec_realtek snd_hda_codec_generic 
snd_hda_intel snd_hda_controller snd_hda_codec snd_hwdep snd_pcm 
snd_seq_midi drm_kms_helper snd_seq_midi_event snd_rawmidi snd_seq drm 
snd_seq_device snd_timer snd soundcore i2c_algo_bit mac_hid nfsd i2c_hid 
hid auth_rpcgss nfs_acl rfcomm nfs bnep bluetooth lockd winbond_cir 
sunrpc rc_core parport_pc dw_dmac dw_dmac_core video 
i2c_designware_platform spi_pxa2xx_platform i2c_designware_core 
binfmt_misc 8250_dw fscache lp nls_iso8859_1 parport ahci libahci 
sdhci_acpi sdhci
[    7.653691] CPU: 1 PID: 372 Comm: systemd-udevd Not tainted 
3.16.0-rc4+ #27
[    7.653692] Hardware name: Intel Corporation Shark Bay Client 
platform/Harris Beach SDS, BIOS HSWLPTU1.86C.0133.R00.1309172123 09/17/2013
[    7.653693] task: ffff880148584b60 ti: ffff880148914000 task.ti: 
ffff880148914000
[    7.653696] RIP: 0010:[<ffffffff81242cee>]  [<ffffffff81242cee>] 
sysfs_remove_link+0xe/0x30
[    7.653697] RSP: 0018:ffff880148917c30  EFLAGS: 00010202
[    7.653698] RAX: ffffffffa08a1028 RBX: ffff880090bef810 RCX: 
0000000000001043
[    7.653698] RDX: 0000000000001042 RSI: 0000000000000000 RDI: 
0000000000000001
[    7.653699] RBP: ffff880148917c30 R08: 00000000000171c0 R09: 
ffff88014f2571c0
[    7.653700] R10: ffffea0002ac20c0 R11: ffffffff814a48a9 R12: 
00000000fffffff0
[    7.653701] R13: ffffffffa08a1028 R14: 0000000000000025 R15: 
0000000000000001
[    7.653702] FS:  00007fd70e437880(0000) GS:ffff88014f240000(0000) 
knlGS:0000000000000000
[    7.653703] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    7.653704] CR2: 0000000000000031 CR3: 000000013d05e000 CR4: 
00000000001407e0
[    7.653705] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
[    7.653706] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 
0000000000000400
[    7.653706] Stack:
[    7.653708]  ffff880148917c48 ffffffff814a0626 ffff880090bef810 
ffff880148917c78
[    7.653710]  ffffffff814a0c2e ffff880090bef810 ffffffffa08a1028 
ffff880090bef870
[    7.653712]  0000000000000000 ffff880148917ca0 ffffffff814a1053 
0000000000000000
[    7.653712] Call Trace:
[    7.653716]  [<ffffffff814a0626>] driver_sysfs_remove+0x26/0x40
[    7.653719]  [<ffffffff814a0c2e>] driver_probe_device+0x8e/0x3e0
[    7.653720]  [<ffffffff814a1053>] __driver_attach+0x93/0xa0
[    7.653722]  [<ffffffff814a0fc0>] ? __device_attach+0x40/0x40
[    7.653725]  [<ffffffff8149ec93>] bus_for_each_dev+0x63/0xa0
[    7.653727]  [<ffffffff814a06ce>] driver_attach+0x1e/0x20
[    7.653728]  [<ffffffff814a02e0>] bus_add_driver+0x180/0x250
[    7.653731]  [<ffffffffa005b000>] ? 0xffffffffa005afff
[    7.653733]  [<ffffffff814a1834>] driver_register+0x64/0xf0
[    7.653735]  [<ffffffff814a2dca>] __platform_driver_register+0x4a/0x50
[    7.653737]  [<ffffffffa005b017>] 
hid_magn_3d_platform_driver_init+0x17/0x1000 [hid_sensor_magn_3d]
[    7.653741]  [<ffffffff8100212c>] do_one_initcall+0xbc/0x1f0
[    7.653744]  [<ffffffff811b239d>] ? kfree+0xfd/0x140
[    7.653747]  [<ffffffff811996f2>] ? __vunmap+0xb2/0x100
[    7.653750]  [<ffffffff810eaf0c>] load_module+0x1cec/0x2700
[    7.653752]  [<ffffffff810e6e10>] ? store_uevent+0x40/0x40
[    7.653755]  [<ffffffff810e79f1>] ? 
copy_module_from_fd.isra.46+0x121/0x180
[    7.653757]  [<ffffffff810eba96>] SyS_finit_module+0x86/0xb0
[    7.653761]  [<ffffffff8173f73f>] tracesys+0xe1/0xe6
[    7.653779] Code: 48 8b 35 8e 16 d5 00 48 8b 57 10 e8 0d de ff ff 5d 
c3 66 2e 0f 1f 84 00 00 00 00 00 90 0f 1f 44 00 00 55 48 85 ff 48 89 e5 
74 12 <48> 8b 7f 30 31 d2 e8 47 dd ff ff 5d c3 0f 1f 44 00 00 48 8b 3d
[    7.653781] RIP  [<ffffffff81242cee>] sysfs_remove_link+0xe/0x30
[    7.653782]  RSP <ffff880148917c30>
[    7.653782] CR2: 0000000000000031
[    7.653785] ---[ end trace 05dd86b8f35f8800 ]---


Other changes, as suggested by Jontahan regarding format, one more
on iio_val in the structure magn_3d_state.


> Any tested-bys, particularly with parts that don't have the new channel
> types, would also be good.
>
> Jonathan
>>   drivers/iio/magnetometer/hid-sensor-magn-3d.c | 111
>> +++++++++++++++++---------
>>   1 file changed, 75 insertions(+), 36 deletions(-)
>>
>> diff --git a/drivers/iio/magnetometer/hid-sensor-magn-3d.c
>> b/drivers/iio/magnetometer/hid-sensor-magn-3d.c
>> index 41cf29e..070d20e 100644
>> --- a/drivers/iio/magnetometer/hid-sensor-magn-3d.c
>> +++ b/drivers/iio/magnetometer/hid-sensor-magn-3d.c
>> @@ -42,7 +42,8 @@ struct magn_3d_state {
>>       struct hid_sensor_hub_callbacks callbacks;
>>       struct hid_sensor_common common_attributes;
>>       struct hid_sensor_hub_attribute_info magn[MAGN_3D_CHANNEL_MAX];
>> -    u32 magn_val[MAGN_3D_CHANNEL_MAX];
>> +    u32 *magn_val_addr[MAGN_3D_CHANNEL_MAX];
>> +    u32 *iio_val;
I prefer iio_vals, as this stores all the values not a single value.

Thanks,
Srinivas
>>       int scale_pre_decml;
>>       int scale_post_decml;
>>       int scale_precision;
>> @@ -221,8 +222,8 @@ static int magn_3d_proc_event(struct
>> hid_sensor_hub_device *hsdev,
>>       dev_dbg(&indio_dev->dev, "magn_3d_proc_event\n");
>>       if (atomic_read(&magn_state->common_attributes.data_ready))
>>           hid_sensor_push_data(indio_dev,
>> -                magn_state->magn_val,
>> -                sizeof(magn_state->magn_val));
>> +                magn_state->iio_val,
>> +                sizeof(magn_state->iio_val));
>>
>>       return 0;
>>   }
>> @@ -236,52 +237,99 @@ static int magn_3d_capture_sample(struct
>> hid_sensor_hub_device *hsdev,
>>       struct iio_dev *indio_dev = platform_get_drvdata(priv);
>>       struct magn_3d_state *magn_state = iio_priv(indio_dev);
>>       int offset;
>> -    int ret = -EINVAL;
>> +    int ret = 0;
>> +    u32 *iio_val = NULL;
> This has me a little confused.  You have an iio_val in your state
> structure and in this function.  I can't actually find anywhere where
> the elements of the one in the state structure are ever assigned to
> anything.
>
>>
>>       switch (usage_id) {
>>       case HID_USAGE_SENSOR_ORIENT_MAGN_FLUX_X_AXIS:
>>       case HID_USAGE_SENSOR_ORIENT_MAGN_FLUX_Y_AXIS:
>>       case HID_USAGE_SENSOR_ORIENT_MAGN_FLUX_Z_AXIS:
>>           offset = usage_id - HID_USAGE_SENSOR_ORIENT_MAGN_FLUX_X_AXIS;
>> -        magn_state->magn_val[CHANNEL_SCAN_INDEX_X + offset] =
>> -                        *(u32 *)raw_data;
>> -        ret = 0;
>> +        iio_val = magn_state->magn_val_addr[CHANNEL_SCAN_INDEX_X +
>> offset];
>> +
>>       break;
>>       default:
>> -        break;
>> +        return -EINVAL;
>>       }
>>
>> +    if(iio_val)
> white space after if please.
>> +        *iio_val = *(u32 *)raw_data;
>> +    else
>> +        ret = -EINVAL;
>> +
>>       return ret;
>>   }
>>
>>   /* Parse report which is specific to an usage id*/
>>   static int magn_3d_parse_report(struct platform_device *pdev,
>>                   struct hid_sensor_hub_device *hsdev,
>> -                struct iio_chan_spec *channels,
>> +                struct iio_chan_spec **channels,
>> +                int *chan_count,
>>                   unsigned usage_id,
>>                   struct magn_3d_state *st)
>>   {
>> -    int ret;
>> +    int ret = 0;
>>       int i;
>> +    int attr_count = 0;
>> +
>> +    /* Scan for each usage attribute supported */
>> +    for (i = 0; i < MAGN_3D_CHANNEL_MAX; i++) {
>> +        u32 address = magn_3d_addresses[i];
>>
>> -    for (i = 0; i <= CHANNEL_SCAN_INDEX_Z; ++i) {
>> +        /* Check if usage attribute exists in the sensor hub device */
>>           ret = sensor_hub_input_get_attribute_info(hsdev,
>> -                HID_INPUT_REPORT,
>> -                usage_id,
>> -                HID_USAGE_SENSOR_ORIENT_MAGN_FLUX_X_AXIS + i,
>> -                &st->magn[CHANNEL_SCAN_INDEX_X + i]);
>> -        if (ret < 0)
>> -            break;
>> -        magn_3d_adjust_channel_bit_mask(channels,
>> -                CHANNEL_SCAN_INDEX_X + i,
>> -                st->magn[CHANNEL_SCAN_INDEX_X + i].size);
> I would have preferred you kept the indenting the same as before. That
> would
> make it more obvious what changed.
>> +            HID_INPUT_REPORT,
>> +            usage_id,
>> +            address,
>> +            &(st->magn[i]));
>> +        if (!ret)
>> +            attr_count++;
>>       }
>> -    dev_dbg(&pdev->dev, "magn_3d %x:%x, %x:%x, %x:%x\n",
>> +
>> +    dev_dbg(&pdev->dev, "magn_3d Found %d usage attributes\n",
>> +            attr_count);
>> +    dev_dbg(&pdev->dev, "magn_3d X: %x:%x Y: %x:%x Z: %x:%x\n",
>>               st->magn[0].index,
>>               st->magn[0].report_id,
>>               st->magn[1].index, st->magn[1].report_id,
>>               st->magn[2].index, st->magn[2].report_id);
>>
>> +    if (attr_count > 0)
>> +        ret = 0;
> This would suggest to me that you want to rename the ret above (used
> to indicate if a channel is there) as something more specific so you
> don't end up appearing to squash and error here...
>> +    else
>> +        return  -EINVAL;
> Again your spacing is messed up. Please fix.
>> +
>> +    /* Setup IIO channel array */
>> +    *channels = devm_kcalloc(&pdev->dev, attr_count,
>> +
> The resulting indenting here is a complete mess. Please fix.
>                                  sizeof(struct iio_chan_spec),
>> +                                GFP_KERNEL);
>> +    if (!*channels) {
>> +        dev_err(&pdev->dev, "failed to allocate space for iio
>> channels\n");
>> +        return -ENOMEM;
>> +    }
>> +
>> +    st->iio_val = devm_kcalloc(&pdev->dev, attr_count,
>> +                                sizeof(u32),
>> +                                GFP_KERNEL);
>> +    if (!st->iio_val) {
>> +        dev_err(&pdev->dev, "failed to allocate space for iio values
>> array\n");
>> +        return -ENOMEM;
>> +    }
>> +
>> +    for (i = 0, *chan_count = 0;
>> +        i < MAGN_3D_CHANNEL_MAX && *chan_count < attr_count;
>> +        i++)
>> +    {
>> +        if (st->magn[i].index >= 0) {
>> +            /* Setup IIO channel struct */
>> +            *channels[*chan_count] = magn_3d_channels[i];
>> +
>> +            st->magn_val_addr[i] = &(st->iio_val[*chan_count]);
>> +            magn_3d_adjust_channel_bit_mask(*channels, *chan_count,
>> st->magn[i].size);
> The above should be wrapped appropriately.
>> +            (*chan_count)++;
>> +        }
>> +    }
>> +
>>       st->scale_precision = hid_sensor_format_scale(
>>                   HID_USAGE_SENSOR_COMPASS_3D,
>>                   &st->magn[CHANNEL_SCAN_INDEX_X],
>> @@ -311,6 +359,7 @@ static int hid_magn_3d_probe(struct
>> platform_device *pdev)
>>       struct magn_3d_state *magn_state;
>>       struct hid_sensor_hub_device *hsdev = pdev->dev.platform_data;
>>       struct iio_chan_spec *channels;
>> +    int chan_count = 0;
>>
>>       indio_dev = devm_iio_device_alloc(&pdev->dev,
>>                         sizeof(struct magn_3d_state));
>> @@ -331,22 +380,15 @@ static int hid_magn_3d_probe(struct
>> platform_device *pdev)
>>           return ret;
>>       }
>>
>> -    channels = kmemdup(magn_3d_channels, sizeof(magn_3d_channels),
>> -               GFP_KERNEL);
>> -    if (!channels) {
>> -        dev_err(&pdev->dev, "failed to duplicate channels\n");
>> -        return -ENOMEM;
>> -    }
>> -
>> -    ret = magn_3d_parse_report(pdev, hsdev, channels,
>> -                HID_USAGE_SENSOR_COMPASS_3D, magn_state);
>> +    ret = magn_3d_parse_report(pdev, hsdev, &channels,
>> +                &chan_count, HID_USAGE_SENSOR_COMPASS_3D, magn_state);
>>       if (ret) {
>>           dev_err(&pdev->dev, "failed to setup attributes\n");
>> -        goto error_free_dev_mem;
>> +        return ret;
>>       }
>>
>>       indio_dev->channels = channels;
>> -    indio_dev->num_channels = ARRAY_SIZE(magn_3d_channels);
>> +    indio_dev->num_channels = chan_count;
>>       indio_dev->dev.parent = &pdev->dev;
>>       indio_dev->info = &magn_3d_info;
>>       indio_dev->name = name;
>> @@ -356,7 +398,7 @@ static int hid_magn_3d_probe(struct
>> platform_device *pdev)
>>           NULL, NULL);
>>       if (ret) {
>>           dev_err(&pdev->dev, "failed to initialize trigger buffer\n");
>> -        goto error_free_dev_mem;
>> +        return ret;
>>       }
>>       atomic_set(&magn_state->common_attributes.data_ready, 0);
>>       ret = hid_sensor_setup_trigger(indio_dev, name,
>> @@ -390,8 +432,6 @@ error_remove_trigger:
>>       hid_sensor_remove_trigger(&magn_state->common_attributes);
>>   error_unreg_buffer_funcs:
>>       iio_triggered_buffer_cleanup(indio_dev);
>> -error_free_dev_mem:
>> -    kfree(indio_dev->channels);
>>       return ret;
>>   }
>>
>> @@ -406,7 +446,6 @@ static int hid_magn_3d_remove(struct
>> platform_device *pdev)
>>       iio_device_unregister(indio_dev);
>>       hid_sensor_remove_trigger(&magn_state->common_attributes);
>>       iio_triggered_buffer_cleanup(indio_dev);
>> -    kfree(indio_dev->channels);
>>
>>       return 0;
>>   }
>>
>
>

